import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShimmerListView extends StatelessWidget {
  const ShimmerListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.black,
                width: double.infinity,
                height: 250,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.black,
                width: 300,
                height: 15,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.black,
                width: 200,
                height: 15,
              ),
            ],
          ),
        );
      },
      itemCount: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}


class ShimmerCategoryGrid extends StatelessWidget {
  const ShimmerCategoryGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    for (int i = 0; i < 10; i++) {
      list.add(Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[400],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child:Container(
                  color: Colors.grey[500],
                  height: 100,
                ),
              ),
            ),
            Container(height: 15, width: double.infinity,),
          ],
        ),
      ));
    }

    return GridView.count(
      children: list,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: ((MediaQuery
          .of(context)
          .size
          .width / 2) /
          (MediaQuery
              .of(context)
              .size
              .width / 2.5)),
    );
  }
}