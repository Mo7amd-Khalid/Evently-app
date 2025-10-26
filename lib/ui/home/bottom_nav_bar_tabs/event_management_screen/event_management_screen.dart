import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:evently/ui/wigdets/app_dialogs.dart';
import 'package:evently/validation/data_validation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../modules/category_dm.dart';
import '../../../../modules/event_dm.dart';
import '../../../firebase/event_firebase.dart';

class EventManagementScreen extends StatefulWidget {

  static const String routeName = "Event Management Screen";
  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  int selectedTab = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<CategoryDM> category = CategoryDM.categoriesList;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Create Event",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 360/200,
                    child: Image.asset(category[selectedTab].image)),
            ),
            SizedBox(
              height: 10,
            ),
            DefaultTabController(
                length: category.length,
                child: TabBar(
                  onTap: (index){
                    setState(() {
                      selectedTab = index;
                    });

                  },
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicator: BoxDecoration(),
                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
                  dividerHeight: 0,
                  indicatorPadding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.start,
                  tabs: category.map((e) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: selectedTab == e.id? AppColors.purple : AppColors.lightBlue,
                        border: Border.all(
                            color: AppColors.purple
                        )
                    ),
                    child: Tab(
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(e.icon,color: selectedTab == e.id? AppColors.white : AppColors.purple,),
                          Text(provider.isEN()? e.nameEN : e.nameAR, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color:selectedTab == e.id? AppColors.white : AppColors.purple),),
                        ],
                      ),
                    ),
                  )).toList(),
                )),
            SizedBox(
              height: 10,
            ),
            Text(
                "Title",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => DataValidation.titleEventValidator(value!, AppLocalizations.of(context)!),
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Event Title",
                prefixIcon: Icon(Icons.edit)
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              "Description",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => DataValidation.descriptionEventValidator(value!, AppLocalizations.of(context)!),
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: "Event Description",
              ),
            ),

            Row(
              children: [
                Icon(Icons.calendar_month_outlined),
                SizedBox(width: 10,),
                Text(
                    selectedDate == null ? "Event Date" : DateFormat("dd/MM/yyyy").format(selectedDate!)),
                Spacer(),
                TextButton(
                    onPressed: (){
                      showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: selectedDate??DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365))).then((value){
                            setState(() {
                              selectedDate = value;
                            });
                      });
                    },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.none
                    )
                  ),
                    child: Text("Choose Date"),
                )
              ],
            ),
            Row(
              children: [
                Icon(Icons.watch_later_outlined),
                SizedBox(width: 10,),
                Text(
                    selectedTime == null? "Event Time" : DateFormat("h:mm a").format(DateTime(0,0,0,selectedTime!.hour,selectedTime!.minute))),
                Spacer(),
                TextButton(
                  onPressed: (){
                    showTimePicker(context: context, initialTime: selectedTime??TimeOfDay.now()).then((value){
                      setState(() {
                        selectedTime = value;
                      });

                    });
                  },
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none
                      )
                  ),
                  child: Text("Choose Time"),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              "Location",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
                onPressed: (){},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(8)
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      height: MediaQuery.sizeOf(context).height*0.05,
                      width: MediaQuery.sizeOf(context).width*0.11,
                      child: Icon(
                        Icons.my_location_outlined,
                        color: AppColors.lightBlue,
                        size: 24,
                      ),
                    ),
                    Text(
                        "Choose Event Location",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                )),

            SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: (){
                  String errorMessage = "";
                  if(titleController.text.isEmpty)
                    {
                      errorMessage += "\nThe Title is required";
                    }
                  if(descriptionController.text.isEmpty)
                    {
                      errorMessage += "\nThe Description is required";
                    }
                  if(selectedTime == null)
                    {
                      errorMessage += "\nThe Time is required";
                    }
                  if(selectedDate == null)
                    {
                      errorMessage += "\nThe Date is required";
                    }

                  if(errorMessage.isEmpty)
                    {
                      AppDialogs.loadingDialog(context: context, loadingMessage: "Loading...");
                      EventManagementFirebase.addEvent(EventDM(
                        id: "",
                        title: titleController.text,
                        description: descriptionController.text,
                        category: category[selectedTab],
                        date: selectedDate!.millisecondsSinceEpoch,
                        time: DateTime(0,0,0,selectedTime!.hour,selectedTime!.minute).millisecondsSinceEpoch)).then((value){
                          Navigator.pop(context);
                          AppDialogs.actionDialog(
                              context: context,
                            title: "Add Event",
                            content: "Event Added Successfully",
                            posActionTitle: "OK",
                            posAction: (){
                                Navigator.pop(context);
                            }
                              );
                      }).onError((error,_){
                        Navigator.pop(context);
                        AppDialogs.actionDialog(
                          context: context,
                          title: "Failed Event",
                          content: error.toString(),
                          posActionTitle: "Try Again",
                        );
                      });
                    }
                  else
                    {
                      AppDialogs.actionDialog(
                          context: context,
                        title: "Invalid Data",
                        content: errorMessage.trim(),
                        posActionTitle: "Try Again",
                      );
                    }

                },
                child: Text(
                    "Add Event",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white),
                )),

          ],
        ),
      ),
    );
  }
}
