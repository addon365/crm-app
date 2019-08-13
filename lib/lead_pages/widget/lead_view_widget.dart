import 'package:crm_app/dependency/constants.dart';

import 'package:crm_app/model/lead.dart';
import 'package:crm_app/model/lead_comment.dart';
import 'package:crm_app/model/lead_history.dart';
import 'package:crm_app/repository/lead_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLeadWidget extends StatelessWidget {
  final Lead lead;
  final Function updateLeadStatus;
  final LeadRepository leadRepository;
  final Function move;

  ViewLeadWidget(
      this.lead, this.updateLeadStatus, this.leadRepository, this.move);

  Widget createTitleWidget(BuildContext context, String title) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Select Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: Constants.leadStatuses.map((l) {
                  return FlatButton(
                    child: Text(l.name),
                    onPressed: () {
                      updateLeadStatus(l);
                    },
                  );
                }).toList(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //region Local Widget members
    final commentsWidget = ListView.builder(
        itemCount: lead.history.length,
        itemBuilder: (BuildContext context, int index) {
          final LeadHistory aHistory = lead.history[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text(aHistory.status.name[0].toUpperCase()),
            ),
            title: getExtraData(aHistory),
            trailing: Text(Constants.formatDate(aHistory.statusDate)),
          );
        });
    final companyNameWidget = Container(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        subtitle: Text(
          "Vellore, Panruti",
          style: TextStyle(color: Colors.white),
        ),
        title: Text(
          this.lead.businessContact.businessName,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final proprietorWidget = this.lead.businessContact.proprietor == null ||
            this.lead.businessContact.proprietor.firstName == null
        ? Container()
        : Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Proprietor Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  onTap: () => {
                    launch(
                        "tel://${this.lead.businessContact.proprietor.mobileNumber}")
                  },
                  title:
                      Text("${this.lead.businessContact.proprietor.firstName}"),
                  subtitle: Text(
                      "${this.lead.businessContact.proprietor.mobileNumber}"),
                  trailing: Icon(FontAwesomeIcons.phone),
                )
              ],
            ),
          );
    final contactPersonWidget = Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Contact Person Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text("${this.lead.businessContact.contactPerson.firstName}"),
            subtitle:
                Text("${this.lead.businessContact.contactPerson.mobileNumber}"),
            trailing: Icon(FontAwesomeIcons.phone),
          )
        ],
      ),
    );
    //endregion

    //region Bottom Button bars
    final buttonBarWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            this.move(-1);
          },
          child: Text("Previous"),
        ),
        RaisedButton(
          onPressed: () {
            showBottomSheet(context);
          },
          child: Text("Update Status"),
        ),
        RaisedButton(
          onPressed: () {
            this.move(1);
          },
          child: Text("Next"),
        )
      ],
    );
    //endregion
    return Column(
      children: <Widget>[
        companyNameWidget,
        proprietorWidget,
        contactPersonWidget,
        Expanded(child: commentsWidget),
        buttonBarWidget
      ],
    );
  }

  Widget getExtraData(LeadHistory aHistory) {
    if (aHistory.extraData == null) return Text("N/A");
    LeadComment leadComment = leadRepository.getLeadComment(aHistory.extraData);
    if (leadComment.type == "audio") {
      //TODO: PlayerWidget error need to be fixed until return empty container
      //return new PlayerWidget(leadComment.comment);
      return new Container();
    }
    return Text("${leadComment.comment}");
  }
}
