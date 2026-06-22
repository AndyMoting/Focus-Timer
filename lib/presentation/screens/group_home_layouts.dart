part of 'group_list_screen.dart';

class _TodoHomeLayouts extends StatefulWidget {
  final TodoHomeLayout layout;
  final List<TaskList> groups;
  final void Function(int oldIndex, int newIndex) onReorder;

  const _TodoHomeLayouts({
    required this.layout,
    required this.groups,
    required this.onReorder,
  });

  @override
  State<_TodoHomeLayouts> createState() => _TodoHomeLayoutsState();
}

class _TodoHomeLayoutsState extends State<_TodoHomeLayouts>
    with SingleTickerProviderStateMixin {
  late TodoHomeLayout _visibleLayout;
  TodoHomeLayout? _outgoingLayout;
  late final AnimationController _controller;
  var _switchToken = 0;

  @override
  void initState() {
    super.initState();
    _visibleLayout = widget.layout;
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void didUpdateWidget(covariant _TodoHomeLayouts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.layout != _visibleLayout) {
      _switchLayout(widget.layout);
    }
  }

  Future<void> _switchLayout(TodoHomeLayout nextLayout) async {
    final token = ++_switchToken;
    setState(() {
      _outgoingLayout = _visibleLayout;
      _visibleLayout = nextLayout;
    });

    await _controller.forward(from: 0);
    if (mounted && token == _switchToken) {
      setState(() => _outgoingLayout = null);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incoming = KeyedSubtree(
      key: ValueKey('todo-home-incoming-${_visibleLayout.name}'),
      child: _buildLayout(context, _visibleLayout),
    );
    final outgoingLayout = _outgoingLayout;
    if (outgoingLayout == null) return incoming;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        final outgoingProgress = (progress / 0.72).clamp(0.0, 1.0);
        final incomingProgress = ((progress - 0.08) / 0.92).clamp(0.0, 1.0);
        final outgoingOpacity =
            1 - Curves.easeOutCubic.transform(outgoingProgress);
        final incomingOpacity = Curves.easeOutCubic.transform(incomingProgress);

        return ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              IgnorePointer(
                child: Opacity(
                  opacity: outgoingOpacity,
                  child: KeyedSubtree(
                    key: ValueKey('todo-home-outgoing-${outgoingLayout.name}'),
                    child: _buildLayout(context, outgoingLayout),
                  ),
                ),
              ),
              Opacity(opacity: incomingOpacity, child: incoming),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, TodoHomeLayout layout) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 720 ? 3 : 2;
    if (layout == TodoHomeLayout.list) {
      return ReorderableListView.builder(
        key: const PageStorageKey('todo-home-list'),
        padding: const EdgeInsets.all(16),
        itemCount: widget.groups.length,
        buildDefaultDragHandles: false,
        onReorderItem: widget.onReorder,
        itemBuilder: (_, i) => ReorderableDelayedDragStartListener(
          key: ValueKey('list-group-${widget.groups[i].id}'),
          index: i,
          child: _GroupCard(group: widget.groups[i]),
        ),
      );
    }

    return GridView.builder(
      key: const PageStorageKey('todo-home-grid'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 190,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.groups.length,
      itemBuilder: (_, i) => KeyedSubtree(
        key: ValueKey('grid-group-${widget.groups[i].id}'),
        child: _GroupCard(group: widget.groups[i], compact: true),
      ),
    );
  }
}
