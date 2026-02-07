import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:flutter/material.dart';

class EventMapItem extends StatelessWidget {
  const EventMapItem({super.key, required this.event});

  final EventDM event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Image.asset(
              width: context.widthSize * 0.37,
              fit: BoxFit.cover,
              event.category.image,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.widthSize * 0.33,
                child: Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 100,
                    child: Text(
                      event.address,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
