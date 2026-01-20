import 'dart:io';

import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../firebase/firebase_auth_services.dart';
import '../../../presentation/widgets/app_dialogs.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ValueNotifier<String?> profileImage = ValueNotifier(FirebaseAuthServices.getUserData()!.photoURL);

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var locale = AppLocalizations.of(context)!;
    var provider = Provider.of<AppConfigProvider>(context);
    print(profileImage.value);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children:[
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                height: size.height*0.23,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(70)
                    )
                ),
                child: SafeArea(
                  child: Row(
                    spacing: 10,
                    children: [
                      // profile image
                      ValueListenableBuilder(
                        valueListenable: profileImage,
                        builder:(context, value, child) => Container(
                          width: size.width*0.35,
                          height: size.height*0.3,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70),
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ), // round
                            image: DecorationImage(
                              image: value == null? AssetImage("assets/images/user_image.jpg"): FileImage(File(value)),
                              fit: BoxFit.fill
                            ),// ed square shape
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children:[
                              CircleAvatar(
                                backgroundColor: AppColors.gray,
                                child: IconButton(
                                    onPressed: (){
                                      _pickImage(ImageSource.gallery);
                                    },
                                    icon: Icon(Icons.camera_alt_outlined)),
                              )
                            ]
                          ),
                        ),
                      ),
                      // data user
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            FirebaseAuthServices.getUserData()!.displayName??"" ,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.white,fontSize: 26),),
                          Text(
                            FirebaseAuthServices.getUserData()!.email??"" ,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.white),),

                        ],
                      )
                    ],
                  ),
                ),
                            ),
              ),
              Padding(
                  padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        locale.language,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: provider.isDark()? AppColors.white:AppColors.black),
                    ),
                    SizedBox(height: 10,),
                    // language drop down
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
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
                      ),
                      initialValue: provider.isEN()?locale.en:locale.ar,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down_outlined,color: Theme.of(context).colorScheme.primary,),
                      focusColor: Theme.of(context).colorScheme.primary,
                      items: [locale.en,locale.ar].map((e)=>DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.titleLarge
                          ))).toList(),
                        onChanged: (value){
                        provider.changeLocale(value==locale.en?"en":"ar");
                        }),
                    SizedBox(height: 20,),
                    // theme drop down
                    Text(
                      locale.theme,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: provider.isDark()? AppColors.white:AppColors.black),
                    ),
                    SizedBox(height: 10,),
                    // theme drop down
                    DropdownButtonFormField<ThemeMode>(
                        decoration: InputDecoration(
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
                        ),
                        initialValue: provider.isDark()?ThemeMode.dark:ThemeMode.light,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Theme.of(context).colorScheme.primary,),
                        focusColor: Theme.of(context).colorScheme.primary,
                        items: [ThemeMode.light,ThemeMode.dark].map((e)=>DropdownMenuItem(
                            value: e,
                            child: Text(
                                e==ThemeMode.light?locale.light:locale.dark,
                                style: Theme.of(context).textTheme.titleLarge
                            ))).toList(),
                        onChanged: (value){
                          provider.changeTheme(value??ThemeMode.light);
                        }),


                  ],
                ),
              ),
            ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.red
              ),
              onPressed: (){
                AppDialogs.loadingDialog(
                  context: context,
                  loadingMessage: "Loading",
                  dismissable: false,
                );
                FirebaseAuthServices.logout().then((e){
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.login);
                }).onError((error,_){
                  Navigator.pop(context);
                  AppDialogs.actionDialog(
                    context: context,
                    title: "Logout Failed",
                    content: error.toString(),
                    posActionTitle: "Try Again",
                  );
                });

              },
              child:Row(
                spacing: 5,
                children: [
                  Icon(Icons.logout_outlined,size: 28,),
                  Text(locale.logout,),
                ],
              )),
        )
      ],
    );
  }
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      await FirebaseAuthServices.updateImageProfile(pickedFile.path);
      profileImage.value = pickedFile.path;
    }
  }

}

