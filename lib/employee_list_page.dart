import 'package:crm_app/dependency/constants.dart';
import 'package:crm_app/model/employee.dart';
import 'package:flutter/material.dart';

class EmployeeListPage extends StatelessWidget {
  static const String routeName = '/list-employee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee List"),
      ),
      body: ListView.builder(
          itemCount: Constants.employees.length,
          itemBuilder: (context, index) {
            Employee employee = Constants.employees[index];
            return ListTile(
              onTap: () {
                onItemSelected(context, employee);
              },
              title: Text(employee.user.userName),
            );
          }),
    );
  }

  void onItemSelected(BuildContext context, Employee selectedEmployee) {
    Navigator.pop(context, selectedEmployee.user);
  }
}
