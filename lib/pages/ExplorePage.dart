import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List listData = [];

  @override
  void initState() {
    API().getCategories((code, response) async {
      setState(() {
        listData = response["data"];
      });
      print(listData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawerEnableOpenDragGesture: false,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  'Explore More',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 44,
                      color: CustomColors().black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              listData == []
                  ? Container()
                  : gridWidgetDashboard(width, context, listData),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  GridView gridWidgetDashboard(
    double width,
    BuildContext context,
    List<dynamic> listOfLocation1,
  ) {
    print(listOfLocation1);
    print("grid");
    bool isSelected = false;
    return GridView.count(
      controller: new ScrollController(keepScrollOffset: false),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: ((MediaQuery.of(context).size.width / 2) /
          (MediaQuery.of(context).size.width / 2.5)),
      physics: BouncingScrollPhysics(),
      children: listOfLocation1.map((data) {
        print("data");
        print(data);
        return MaterialButton(
          padding: EdgeInsets.all(0),
          minWidth: width,
          onPressed: () {},
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: CustomColors().grey),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: data['image_link'] == null
                        ? Container(
                            color: Colors.white30,
                          )
                        : Image.network(
                            data['image_link'] == null
                                ? 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z2lybCUyMGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80'
                                : data['image_link'],
                            height: 50,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
                Text(
                  data['tags_name'].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}
