import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/option_item_model.dart';

class OptionView extends StatefulWidget {
  final OptionItemModel option;
  final int index;
  final ValueChanged<OptionItemModel> onUpdate;
  final VoidCallback onDelete;

  const OptionView({
    super.key,
    required this.option,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<OptionView> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionView>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  bool _isEditingName = false;
  bool _isEditingValue = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.option.name);
    _valueController = TextEditingController(
      text: widget.option.score.toString(),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(OptionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.option.score != widget.option.score && !_isEditingValue) {
      _valueController.text = widget.option.score.toString();
      if (!widget.option.isLocked) {
        _shakeController.forward(from: 0);
      }
    }
    if (oldWidget.option.name != widget.option.name && !_isEditingName) {
      _nameController.text = widget.option.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _saveName() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.option.name) {
      widget.onUpdate(widget.option.copyWith(name: newName));
    } else {
      _nameController.text = widget.option.name;
    }
    setState(() => _isEditingName = false);
  }

  void _saveValue() {
    final val = int.tryParse(_valueController.text);
    if (val != null && val >= 1 && val <= 20) {
      widget.onUpdate(widget.option.copyWith(score: val));
    } else {
      _valueController.text = widget.option.score.toString();
    }
    setState(() => _isEditingValue = false);
  }

  void _randomizeValue() {
    if (widget.option.isLocked) {
      return;
    }
    var score = Random().nextInt(20) + 1;
    widget.onUpdate(widget.option.copyWith(score: score));
    _shakeController.forward(from: 0);
  }

  void _toggleLock() {
    widget.onUpdate(widget.option.copyWith(isLocked: !widget.option.isLocked));
  }

  Color get _valueColor {
    final v = widget.option.score;
    if (v >= 15) return const Color(0xFF4FC3F7);
    if (v >= 10) return const Color(0xFF81C784);
    if (v >= 5) return const Color(0xFFFFB74D);
    return const Color(0xFFE57373);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textScheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withValues(alpha: 0.1);
    final isLocked = widget.option.isLocked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: widget.index.isOdd ? oddItemColor : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ReorderableDragStartListener(
                  index: widget.index,
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    size: 20,
                  ),
                ),
              ),

              // Name (editable on tap)
              Expanded(
                child: _isEditingName
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(isDense: true),
                          onSubmitted: (_) => _saveName(),
                          onTapOutside: (_) => _saveName(),
                        ),
                      )
                    : ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        dense: true,
                        title: Text(
                          widget.option.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => setState(() => _isEditingName = true),
                      ),
              ),

              // Score badge (editable on tap)
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    sin(_shakeAnimation.value * pi * 6) *
                        4 *
                        (1 - _shakeAnimation.value),
                    0,
                  ),
                  child: child,
                ),
                child: _isEditingValue
                    ? SizedBox(
                        width: 52,
                        child: TextField(
                          controller: _valueController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _valueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(isDense: true),
                          onSubmitted: (_) => _saveValue(),
                          onTapOutside: (_) => _saveValue(),
                        ),
                      )
                    : GestureDetector(
                        onTap: isLocked
                            ? null
                            : () => setState(() => _isEditingValue = true),
                        child: Container(
                          width: 40,
                          height: 28,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: _valueColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _valueColor.withValues(alpha: 0.35),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.option.score}',
                            style: TextStyle(
                              color: _valueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
              ),

              // Action buttons
              Tooltip(
                message: 'Score aléatoire',
                child: IconButton(
                  icon: const Icon(Icons.casino_rounded),
                  color: isLocked
                      ? textScheme.bodyMedium?.color?.withValues(alpha: 0.2)
                      : null,
                  onPressed: isLocked ? null : _randomizeValue,
                ),
              ),
              Tooltip(
                message: isLocked ? 'Déverrouiller' : 'Verrouiller',
                child: IconButton(
                  icon: Icon(
                    isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                  ),
                  onPressed: _toggleLock,
                ),
              ),
              Tooltip(
                message: 'Supprimer',
                child: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: widget.onDelete,
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
          // Séparateur
          Divider(
            height: 1,
            thickness: 1,
            indent: 28,
            color: colorScheme.primary.withValues(alpha: 0.06),
          ),
        ],
      ),
    );
  }
}
