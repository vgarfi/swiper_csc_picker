import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownWithSearch<T> extends StatelessWidget {
  final String title;
  final String placeHolder;
  final T selected;
  final List items;
  final Function onChanged;
  final String label;

  // Styling parameters
  final TextStyle? selectedItemStyle;
  final TextStyle? titleStyle;
  final TextStyle? itemStyle;
  final TextStyle? hintStyle;
  final BoxDecoration? decoration;
  final BoxDecoration? disabledDecoration;
  final EdgeInsets? padding;
  final double borderRadius;
  final double? dialogRadius;
  final double? searchBarRadius;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final Color? iconColor;
  final Color? dialogBackgroundColor;
  final double? elevation;
  final bool disabled;
  final bool? isArabic;
  final IconData? dropdownIcon;

  const DropdownWithSearch({
    super.key,
    required this.title,
    required this.placeHolder,
    required this.items,
    required this.selected,
    required this.onChanged,
    required this.label,
    this.selectedItemStyle,
    this.titleStyle,
    this.itemStyle,
    this.hintStyle,
    this.decoration,
    this.disabledDecoration,
    this.padding,
    this.borderRadius = 30.0,
    this.dialogRadius,
    this.searchBarRadius,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.disabledBorderColor,
    this.iconColor,
    this.dialogBackgroundColor,
    this.elevation,
    this.disabled = false,
    this.isArabic,
    this.dropdownIcon,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: kIsWeb ? 30 : 22,
          vertical: kIsWeb ? 22 : 16,
        );

    final effectiveBackgroundColor = backgroundColor ?? Colors.white;
    final effectiveDisabledBackgroundColor = disabledBackgroundColor ?? Colors.grey.shade300;
    final effectiveBorderColor = borderColor ?? Colors.grey.shade600;
    final effectiveDisabledBorderColor = disabledBorderColor ?? Colors.grey.shade300;
    final effectiveIconColor = iconColor ?? Colors.grey.shade600;

    return AbsorbPointer(
      absorbing: disabled,
      child: GestureDetector(
        onTap: disabled
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (context) => SearchDialog(
                    placeHolder: placeHolder,
                    title: title,
                    items: items,
                    titleStyle: titleStyle,
                    itemStyle: itemStyle,
                    hintStyle: hintStyle,
                    searchInputRadius: searchBarRadius ?? borderRadius,
                    dialogRadius: dialogRadius ?? 20.0,
                    displayArabic: isArabic,
                    backgroundColor: dialogBackgroundColor ?? Colors.white,
                    elevation: elevation ?? 15.0,
                  ),
                ).then((value) {
                  if (value != null) {
                    onChanged(value);
                  }
                });
              },
        child: Container(
          padding: effectivePadding,
          decoration: !disabled
              ? decoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: effectiveBackgroundColor,
                    border: Border.all(color: effectiveBorderColor, width: 1),
                  )
              : disabledDecoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: effectiveDisabledBackgroundColor,
                    border: Border.all(color: effectiveDisabledBorderColor, width: 1),
                  ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selected.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: selectedItemStyle ??
                      GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: disabled ? Colors.grey.shade500 : Colors.black,
                        ),
                      ),
                ),
              ),
              Icon(
                dropdownIcon ?? Icons.keyboard_arrow_down_rounded,
                color: disabled ? Colors.grey.shade400 : effectiveIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDialog extends StatefulWidget {
  final String title;
  final String placeHolder;
  final List items;
  final TextStyle? titleStyle;
  final TextStyle? itemStyle;
  final TextStyle? hintStyle;
  final double searchInputRadius;
  final double dialogRadius;
  final bool? displayArabic;
  final Color backgroundColor;
  final double elevation;

  const SearchDialog({
    super.key,
    required this.title,
    required this.placeHolder,
    required this.items,
    this.titleStyle,
    this.itemStyle,
    this.hintStyle,
    this.searchInputRadius = 30.0,
    this.dialogRadius = 20.0,
    this.displayArabic,
    this.backgroundColor = Colors.white,
    this.elevation = 15.0,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _textController = TextEditingController();
  late List _filteredList;

  @override
  void initState() {
    super.initState();
    _initializeFilteredList();
    _textController.addListener(_filterItems);
  }

  void _initializeFilteredList() {
    if (widget.items is List<String?>) {
      _filteredList = List.from(widget.items);
    } else {
      _filteredList = widget.items.map((e) => widget.displayArabic == true ? e.nameAr : e.name).toList();
    }
  }

  void _filterItems() {
    setState(() {
      if (_textController.text.isEmpty) {
        _initializeFilteredList();
      } else {
        final searchText = _textController.text.toLowerCase();
        if (widget.items is List<String?>) {
          _filteredList =
              widget.items.where((element) => element.toString().toLowerCase().contains(searchText)).toList();
        } else {
          _filteredList = widget.items
              .where((element) {
                return element.name.toString().toLowerCase().contains(searchText) ||
                    element.nameAr.toString().toLowerCase().contains(searchText);
              })
              .map((e) => widget.displayArabic == true ? e.nameAr : e.name)
              .toList();
        }
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.dialogRadius),
      ),
      elevation: widget.elevation,
      backgroundColor: widget.backgroundColor,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 280.0,
          minHeight: 280.0,
          maxHeight: 500.0,
          maxWidth: 400.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildItemsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: widget.titleStyle ??
                  GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.grey.shade600,
            iconSize: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: _textController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.placeHolder,
          hintStyle: widget.hintStyle ??
              GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.searchInputRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.searchInputRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.searchInputRadius),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? 20 : 16,
            vertical: kIsWeb ? 18 : 14,
          ),
        ),
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Expanded(
      child: _filteredList.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _filteredList.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Colors.grey,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(_filteredList[index]);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      _filteredList[index].toString(),
                      style: widget.itemStyle ??
                          GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
