import 'package:crm_app/model/view/lead_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeadListWidget extends StatefulWidget {
  @override
  _LeadListWidgetState createState() => _LeadListWidgetState();

  final List<LeadViewModel> _leadViewModel;
  final Function onSelected;

  final RefreshCallback refresh;

  LeadListWidget(this._leadViewModel, this.onSelected, this.refresh);
}

class _LeadListWidgetState extends State<LeadListWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {}

  @override
  Widget build(BuildContext context) {
    return this.widget._leadViewModel == null ||
            this.widget._leadViewModel.length == 0
        ? Center(
            child: InkWell(child: Text("No Leads Found"),onTap: (){this.widget.refresh();},),
          )
        : RefreshIndicator(
            semanticsLabel: "No Leads Found yet",
            child: ListView.builder(
                itemCount: this.widget._leadViewModel.length,
                itemBuilder: (BuildContext context, int index) {
                  var viewModel = this.widget._leadViewModel[index];
                  return ListTile(
                    onTap: () => this.widget.onSelected(index),
                    title: Text(viewModel.companyName),
                    leading: CircleAvatar(
                      child: Text(viewModel.statusName[0].toUpperCase()),
                    ),
                    trailing: Icon(FontAwesomeIcons.chevronRight),
                  );
                }),
            onRefresh: this.widget.refresh);
  }
}
