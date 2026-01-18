import 'package:evently/ui/firebase/event_firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import '../../../modules/category_dm.dart';
import '../../../provider/app_config_provider.dart';
import '../../firebase/firebase_auth_services.dart';
import '../../wigdets/event_card.dart';

class HomeTabScreen extends StatefulWidget {

  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {

  CategoryDM? selectedCategory;
  List<CategoryDM>category = [];

  @override
  void initState() {
    super.initState();
    category.add(
        CategoryDM(
            id: -1,
            nameEN: "All",
            nameAR: "الكل",
            image: "",
            icon: Icons.explore));
    category.addAll(CategoryDM.categoriesList);

    selectedCategory = category.first;
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuthServices.getUserData();
    var provider = Provider.of<AppConfigProvider>(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: provider.isDark()? AppColors.darkPurple : AppColors.purple
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 3,
                            children: [
                              Text(AppLocalizations.of(context)!.welcomeBack, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.white),),
                              Text(user?.displayName??"", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.white),),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: (){
                              provider.changeTheme(provider.isDark()? ThemeMode.light : ThemeMode.dark);
                            },
                            icon: provider.isDark() ? Icon(Icons.dark_mode_outlined,color: AppColors.white,) : Icon(Icons.light_mode_outlined,color: AppColors.white,),
                          ),
                          InkWell(
                            onTap: (){
                              provider.changeLocale(provider.locale == "en"? "ar" : "en");
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.white,
                              ),
                              child: Text(provider.locale.toUpperCase(),style: TextStyle(
                                  color: provider.isDark()? AppColors.darkPurple : AppColors.purple
                              ),),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined,color: AppColors.white,),
                          Text("Cairo, Egypt",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.white),),
                        ],
                      ),
                    ],
                  ),
                ),
                DefaultTabController(
                    length: category.length,
                    child: TabBar(
                      onTap: (index){
                        setState(() {
                          print(index);
                          selectedCategory = category[index];
                        });
                      },
                      isScrollable: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      indicator: BoxDecoration(),
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                      dividerHeight: 0,
                      indicatorPadding: EdgeInsets.zero,
                      tabAlignment: TabAlignment.start,
                      tabs: category.map((e) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: selectedCategory == e? AppColors.lightBlue:Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.white
                            )
                        ),
                        child: Tab(
                          child: Row(
                            spacing: 5,
                            children: [
                              Icon(e.icon,color: selectedCategory == e? Theme.of(context).colorScheme.primary:AppColors.white,),
                              Text(provider.isEN()?e.nameEN : e.nameAR, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: selectedCategory == e? Theme.of(context).colorScheme.primary : AppColors.white,),),
                            ],
                          ),
                        ),
                      )).toList(),
                    ))
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: EventManagementFirebase.getEventsData(selectedCategory!.id),
            builder: (_,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator());
                }
              else if(snapshot.hasData)
                {
                  var events = snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                  return ListView.separated(
                    padding: EdgeInsets.all(16),
                      itemBuilder: (context, index)=>EventCart(event: events[index],),
                      separatorBuilder: (context, index)=>SizedBox(height: 10,),
                      itemCount: events.length);
                }
              else if(snapshot.hasError)
                {
                  return Center(child: Text(snapshot.error.toString()));
                }
              else
                {
                  return SizedBox();
                }

            },
          ),
        )
      ],
    );
  }
}
