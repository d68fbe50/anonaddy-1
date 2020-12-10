import 'package:anonaddy/models/alias_model.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'alias_list_tile.dart';

class DeletedAliasesScreen extends StatelessWidget {
  const DeletedAliasesScreen({Key key, this.aliasDataModel}) : super(key: key);

  final List<AliasDataModel> aliasDataModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kDeletedAliasText),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Text('Total Aliases deleted'),
                        Spacer(),
                        Text(
                          '${aliasDataModel.length}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ExpansionTile(
                title: Row(
                  children: [
                    Icon(Icons.list_alt),
                    SizedBox(width: 6),
                    Text(
                      'View Full List',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                initiallyExpanded: false,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: aliasDataModel.length,
                    itemBuilder: (context, index) {
                      return AliasListTile(
                        aliasData: aliasDataModel[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Deleted Aliases List'),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}