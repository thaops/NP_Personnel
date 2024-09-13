import 'package:flutter/material.dart';
import 'package:hocflutter/Api/api_service.dart';
import 'package:hocflutter/Api/models/employee.dart';
import 'package:hocflutter/widgets/listwidgets/list_widgets.dart';
import 'package:provider/provider.dart';

class ListoffScreen extends StatefulWidget {
  const ListoffScreen({super.key});

  @override
  State<ListoffScreen> createState() => _ListoffScreenState();
}

class _ListoffScreenState extends State<ListoffScreen> {
  List<Employee>? listOff;
  DateTime? _fromDate;
  DateTime? _toDate;

  bool isLoading = true;
  String errorMessage = '';
  late DateTime firstDayOfMonth;
  late DateTime lastDayOfMonth;

  Future<void> _fetchListOff() async {
    final _apiService = Provider.of<ApiService>(context, listen: false);
    final accessToken = _apiService.accessTokenId;
    try {
      final response = await _apiService.getListOff(
          accessToken, firstDayOfMonth, lastDayOfMonth, context);
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

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1); // Ngày đầu tháng
    firstDayOfMonth = _fromDate!;
    _toDate =
        DateTime(now.year, now.month + 1, 0).add(const Duration(days: 10));

    lastDayOfMonth = _toDate!;

    _fetchListOff();
  }

  @override
  Widget build(BuildContext context) {
    print("hii");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn xin phép'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListWidgets(
              listOff: listOff,
            ),
          ],
        ),
      ),
    );
  }
}
