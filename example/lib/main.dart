import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CountryCityPickers extends StatefulWidget {
  final Function(String?)? onCountryChanged;
  final Function(String?)? onStateChanged;
  final Function(String?)? onCityChanged;
  final String? countryHint;
  final String? stateHint;
  final String? cityHint;

  const CountryCityPickers({
    super.key,
    this.onCountryChanged,
    this.onStateChanged,
    this.onCityChanged,
    this.countryHint,
    this.stateHint,
    this.cityHint,
  });

  @override
  State<CountryCityPickers> createState() => _CountryCityPickersState();
}

class _CountryCityPickersState extends State<CountryCityPickers> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return CSCPickerPlus(
      // Nuevos parámetros de estilo
      selectedItemStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      
      titleStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      
      itemStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      
      hintStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      
      // Decoraciones actualizadas
      dropdownDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey.shade600,
          width: 1,
        ),
      ),
      
      disabledDropdownDecoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      
      // Configuración de estilo
      borderRadius: 30.0,
      dropdownDialogRadius: 20.0,
      searchBarRadius: 30.0,
      backgroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey.shade300,
      borderColor: Colors.grey.shade600,
      disabledBorderColor: Colors.grey.shade300,
      iconColor: Colors.grey.shade600,
      dialogBackgroundColor: Colors.white,
      elevation: 15.0,
      
      // Padding responsivo
      padding: EdgeInsets.symmetric(
        horizontal: kIsWeb ? 30 : 22,
        vertical: kIsWeb ? 22 : 16,
      ),
      
      // Labels
      countryDropdownLabel: widget.countryHint ?? "Country",
      stateDropdownLabel: widget.stateHint ?? "State",
      cityDropdownLabel: widget.cityHint ?? "City",
      
      // Configuración
      countryStateLanguage: CountryStateLanguage.englishOrNative,
      cityLanguage: CityLanguage.native,
      showCities: false,
      
      // Callbacks
      onCountryChanged: (value) {
        setState(() {
          _selectedCountry = value;
          _selectedState = null;
          _selectedCity = null;
        });
        widget.onCountryChanged?.call(value);
      },
      
      onStateChanged: (value) {
        setState(() {
          _selectedState = value;
          _selectedCity = null;
        });
        widget.onStateChanged?.call(value);
      },
      
      onCityChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
        widget.onCityChanged?.call(value);
      },
      
      // Estados actuales
      currentCountry: _selectedCountry,
      currentState: _selectedState,
      currentCity: _selectedCity,
    );
  }
}