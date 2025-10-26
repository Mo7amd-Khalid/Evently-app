import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme{
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.purple,
        onPrimary: AppColors.white,
        secondary: AppColors.black,
        onSecondary: AppColors.white,
        error: Colors.red,
        onError: AppColors.white,
        surface: AppColors.lightBlue,
        onSurface: AppColors.purple),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBlue,
      foregroundColor: AppColors.purple,
      elevation: 0,
      surfaceTintColor: Colors.transparent
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        )
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(16),
            textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )
        )
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: TextStyle(
              decoration: TextDecoration.underline,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic
            ),
        ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.purple,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.gray,
        ),

      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.gray,
        ),

      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.gray,
        ),

      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red,
        ),

      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red,
        ),

      ),
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.gray
      ),
      iconColor: AppColors.gray,
      prefixIconColor: AppColors.gray,
      suffixIconColor: AppColors.gray,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.purple
      ),
      titleMedium: TextStyle(
          color: AppColors.purple
      ),
      titleSmall: TextStyle(
        color: AppColors.purple
      ),
      labelLarge: TextStyle(
          color: AppColors.black
      ),
      labelMedium: TextStyle(
          color: AppColors.black
      ),
      labelSmall: TextStyle(
          color: AppColors.black
      ),
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.black),
      bodySmall: TextStyle(color: AppColors.black),

    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.purple,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white,
      elevation: 0
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.purple,
          ),
      ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red,
          ),
    ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.purple,
          ),

      ),
      )
    )
  );



  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.purple,
        onPrimary: AppColors.white,
        secondary: AppColors.white,
        onSecondary: AppColors.darkPurple,
        error: Colors.red,
        onError: AppColors.white,
        surface: AppColors.darkPurple,
        onSurface: AppColors.purple),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPurple,
      foregroundColor: AppColors.purple,
      elevation: 0,
      surfaceTintColor: Colors.transparent
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        )
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(16),
            textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )
        )
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: TextStyle(
              decoration: TextDecoration.underline,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic
            ),
        ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPurple,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.purple,
        ),

      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.purple,
        ),

      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.purple,
        ),

      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red,
        ),

      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red,
        ),

      ),
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.white
      ),
      iconColor: AppColors.white,
      prefixIconColor: AppColors.white,
      suffixIconColor: AppColors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.purple
      ),
      titleMedium: TextStyle(
          color: AppColors.purple
      ),
      titleSmall: TextStyle(
        color: AppColors.purple
      ),
      labelLarge: TextStyle(
          color: AppColors.white
      ),
      labelMedium: TextStyle(
          color: AppColors.white
      ),
      labelSmall: TextStyle(
          color: AppColors.white
      ),
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.white),
      bodySmall: TextStyle(color: AppColors.white),

    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkPurple,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.white,
          elevation: 0
      ),


  );
}