import 'package:flutter/material.dart';

import 'package:app/pages/campaign/CampaignTile.dart';

import 'package:app/models/Campaign.dart';
import 'package:app/models/Campaigns.dart';
import 'package:app/models/ViewModel.dart';
import 'package:app/models/User.dart';
import 'package:app/models/State.dart';

import 'package:app/assets/components/header.dart';
import 'package:app/assets/components/inputs.dart';
import 'package:app/assets/StyleFrom.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

//class CampaignPage extends StatelessWidget {
//
//  CampaignPage();
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, ViewModel>(
//        converter: (Store<AppState> store) => ViewModel.create(store),
//        builder: (BuildContext context, ViewModel viewModel) {
//          print("Before splash screen user is");
//          return CampaignPageBody(viewModel);
//        },
//    );
//  }
//}

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<Campaign> campaigns;
  Campaigns selectedCampaigns;
  User user;
  bool onlyJoined;

  @override
  void initState() {
    campaigns = [];
    onlyJoined = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If given specific campaign, redirect to that page
    // Needs to be in future so happens after render of this page or something like that
    //var _campaigns = widget.model.campaigns.map((Campaign c) => c).toList();
    return 
      Scaffold(
        body: 
          StoreConnector<AppState, ViewModel>(
            onInit: (Store<AppState> store) {
              campaigns = store.state.campaigns.getActiveCampaigns();
              user = store.state.userState.user;
            },
            converter: (Store<AppState> store) => ViewModel.create(store),
            builder: (BuildContext context, ViewModel viewModel) {
              print("In page campaigns");
              print(viewModel.campaigns);
              print(viewModel.campaigns.getActiveCampaigns());
              print(viewModel.campaigns.getActiveCampaigns().toList()[0]);
              print(viewModel.campaigns.getActiveCampaigns().toList()[1]);
              print(viewModel.campaigns.getActiveCampaigns().toList()[2]);
              //campaigns = viewModel.campaigns.getActiveCampaigns().toList();
              //user = viewModel.userModel.user;
              return  SafeArea(
                child: ListView(
                  children: <Widget>[
                    PageHeader(
                      title: "Active Campaigns",
                      onTap: () {},
                      icon: Icons.book,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Show joined campaigns only",
                              style: textStyleFrom(
                                Theme.of(context).primaryTextTheme.bodyText1,
                                color: Color.fromRGBO(63,61,86, 1),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          CustomSwitch(
                            value: onlyJoined,
                            onChanged: (value) {
                              setState(() {
                                onlyJoined = value;
                                if (value) {
                                  campaigns = viewModel.getActiveSelectedCampaings();
                                }
                                else {
                                  campaigns = viewModel.campaigns.getActiveCampaigns();
                                }
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Color.fromRGBO(221,221,221,1)
                          )
                        ],
                      )
                    ),
                    viewModel.getActiveSelectedCampaings().length == 0 && onlyJoined ?
                    Center(
                      child: Text("You havent selecetd any campaigns yet"),
                    )
                    :
                    Container(),
                    Container(
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget> [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: campaigns.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CampaignTile(campaigns[index]);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]
                      ),     
                    ),
                  ], 
                ),
              );
            },
          )
      );
    }
}
