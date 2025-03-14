import 'package:flutter/material.dart';
import 'package:sunu_projet/config/constants_colors.dart';
import 'package:sunu_projet/config/size_config.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintLabel,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isRequired = false,
    this.isDateField = false, // Nouveau : pour les champs de date
    this.isDropdown = false, // Nouveau : pour les champs de priorité
    this.dropdownItems, // Nouveau : liste pour dropdown (ex. priorités)
    this.onDateSelected, // Nouveau : callback pour sélection de date
    this.initialValue, // Nouveau : valeur initiale pour dropdown ou texte
    this.readOnly = false, // Nouveau : champ en lecture seule (ex. date)
    this.maxLines = 1, // Nouveau : pour les descriptions (multiligne)
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintLabel;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isRequired;
  final bool isDateField; // Indique si c'est un champ de date
  final bool isDropdown; // Indique si c'est une liste déroulante
  final List<String>? dropdownItems; // Options pour dropdown (ex. priorités)
  final Function(DateTime)? onDateSelected; // Callback pour la date sélectionnée
  final String? initialValue; // Valeur initiale (texte ou dropdown)
  final bool readOnly; // Champ en lecture seule
  final int maxLines; // Nombre de lignes maximum (pour descriptions)

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  String? _validateField(String? value) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return '${widget.labelText} est obligatoire';
    }
    return widget.validator?.call(value);
  }

  // Gestion de la sélection de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && widget.onDateSelected != null) {
      widget.onDateSelected!(picked);
      widget.controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupération du thème pour supporter clair/sombre
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark ? Colors.white70 : kGrayColor;
    final focusedColor = kPrimaryColor;
    final errorColor = kErrorColor;

    // Si c'est une liste déroulante (ex. priorité)
    if (widget.isDropdown && widget.dropdownItems != null) {
      return DropdownButtonFormField<String>(
        value: widget.initialValue,
        decoration: InputDecoration(
          label: Text(widget.labelText),
          enabledBorder: _buildBorder(color: borderColor),
          focusedBorder: _buildBorder(color: focusedColor),
          errorBorder: _buildBorder(color: errorColor, width: 2),
          focusedErrorBorder: _buildBorder(color: errorColor),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportinateScreenWidth(30),
            vertical: SizeConfig.getProportinateScreenheight(8),
          ),
        ),
        items: widget.dropdownItems!
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            widget.controller.text = value;
          }
        },
        validator: _validateField,
      );
    }

    // Si c'est un champ de date
    if (widget.isDateField) {
      return TextFormField(
        controller: widget.controller,
        readOnly: true, // Empêche la saisie manuelle
        onTap: () => _selectDate(context),
        validator: _validateField,
        decoration: InputDecoration(
          label: Text(widget.labelText),
          hintText: widget.hintLabel ?? 'Sélectionnez une date',
          // enabledBorder: _buildBorder(color: borderColor),
          // focusedBorder: _buildBorder(color: focusedColor),
          // errorBorder: _buildBorder(color: errorColor, width: 2),
          // focusedErrorBorder: _buildBorder(color: errorColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportinateScreenWidth(15),
            vertical: SizeConfig.getProportinateScreenheight(4),
          ),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
      );
    }

    // Champ texte standard
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      validator: _validateField,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        label: Text(widget.labelText),
        hintText: widget.hintLabel ?? '',
        enabledBorder: _buildBorder(color: borderColor),
        focusedBorder: _buildBorder(color: focusedColor),
        errorBorder: _buildBorder(color: errorColor, width: 2),
        focusedErrorBorder: _buildBorder(color: errorColor),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportinateScreenWidth(15),
          vertical: SizeConfig.getProportinateScreenheight(4),
        ),
        errorStyle: const TextStyle(fontSize: 8),
        suffixIcon: Icon(widget.suffixIcon),
        prefixIcon: Icon(widget.prefixIcon),
      ),
    );
  }

  static OutlineInputBorder _buildBorder({
    required Color color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
      borderRadius: BorderRadius.circular(9.0),
    );
  }
}