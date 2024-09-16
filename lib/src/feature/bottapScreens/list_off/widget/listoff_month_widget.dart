import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  final List<Map<String, DateTime>> months;
  final DateTime? selectedMonth;
  final void Function(DateTime firstDay, DateTime lastDay) onMonthSelected;

  const MonthSelector({
    Key? key,
    required this.months,
    required this.selectedMonth,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 120, // Đặt chiều cao cho khu vực danh sách tháng
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Thiết lập cuộn theo chiều ngang
          itemCount: months.length,
          itemBuilder: (context, index) {
            DateTime firstDay = months[index]['firstDay']!;
            DateTime lastDay = months[index]['lastDay']!;
            String monthName = DateFormat('MMMM', 'vi_VN').format(firstDay);
            String yearName = DateFormat('yyyy', 'vi_VN').format(firstDay);
            bool isSelected = selectedMonth == firstDay;

            return GestureDetector(
              onTap: () {
                onMonthSelected(firstDay, lastDay);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: isSelected
                      ? Colors.blueGrey[200]
                      : Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  child: SizedBox(
                    width: 100, // Đặt chiều rộng cụ thể cho Card
                    child: Center(
                      // Sử dụng Center để căn giữa nội dung
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            monthName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            yearName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
