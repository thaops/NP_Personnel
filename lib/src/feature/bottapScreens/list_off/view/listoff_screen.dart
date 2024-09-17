// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Thư viện để định dạng ngày tháng
import 'package:provider/provider.dart';

import 'package:hocflutter/src/Api/models/employee_model.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart'; // Đảm bảo bạn đã định nghĩa các màu trong colors.dart
import 'package:hocflutter/src/feature/bottapScreens/list_off/widget/listoff_add_widget.dart';
import 'package:hocflutter/src/feature/bottapScreens/list_off/widget/listoff_month_widget.dart';
import 'package:hocflutter/src/feature/bottapScreens/list_off/widget/listoff_widgets.dart';

/// Màn hình hiển thị danh sách đơn xin phép
class ListoffScreen extends StatefulWidget {
  final Function(bool) onUpdateCallback;

  const ListoffScreen({
    Key? key,
    required this.onUpdateCallback,
  }) : super(key: key);

  @override
  State<ListoffScreen> createState() => _ListoffScreenState();
}

class _ListoffScreenState extends State<ListoffScreen> {
  List<Employee>? listOff;
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, DateTime>> months = [];
  DateTime? selectedMonth;

  /// Hàm lấy dữ liệu đơn xin phép từ API trong khoảng thời gian từ `firstDay` đến `lastDay`
  Future<void> _fetchListOff(DateTime firstDay, DateTime lastDay) async {
    final _apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = _apiService.accessTokenId;
    try {
      final response =
          await _apiService.getListOff(accessToken, firstDay, lastDay, context);
      setState(() {
        listOff = response ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Đã xảy ra lỗi khi tải dữ liệu';
        isLoading = false;
      });
    }
  }

  /// Hàm khởi tạo danh sách 12 tháng gần đây
  void _generateMonths() {
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      DateTime firstDay = DateTime(now.year, now.month - i, 1);
      DateTime lastDay = DateTime(now.year, now.month - i + 1, 0);
      months.add({
        'firstDay': firstDay,
        'lastDay': lastDay,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateMonths();
    _fetchListOff(months[0]['firstDay']!, months[0]['lastDay']!);
  }

  void _addScreen() {
    GoRouter.of(context)
        .push('/listoffadd', extra: _fetchListOff)
        .then((value) {
      if (value == true) {
        print('Adding screen returned true, updating list...');
        widget.onUpdateCallback(true);
        _fetchListOff(months[0]['firstDay']!, months[0]['lastDay']!);
      } else {
        print('Adding screen did not return true.');
      }
    });
  }

  Future<void> refresh() async {
    await _fetchListOff(months[0]['firstDay']!, months[0]['lastDay']!);
    ;
    setState(() {
      selectedMonth = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.assignment_turned_in_outlined),
              SizedBox(width: 30),
              Text(
                'Đơn Xin Phép',
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              ListoffAddWidget(
                onAdd: _addScreen,
              ),

              MonthSelector(
                months: months,
                selectedMonth: selectedMonth,
                onMonthSelected: (firstDay, lastDay) {
                  setState(() {
                    selectedMonth = firstDay;
                  });
                  _fetchListOff(firstDay, lastDay);
                },
              ),
              // Hiển thị danh sách đơn xin phép
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListWidgets(
                            listOff: listOff,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
