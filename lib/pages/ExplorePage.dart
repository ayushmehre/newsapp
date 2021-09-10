import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:newsapp/dummy/home_screen.dart';
import 'package:newsapp/pages/HomePage.dart';
import 'package:newsapp/utils/api.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:newsapp/widgets/widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List listData = [];
  bool boolsearch_height=false;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory(){
    API().getCategories((code, response) async {
      setState(() {
        listData = response["data"];
      });
      print(listData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
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
                margin: EdgeInsets.fromLTRB(0, 20, 16, 0),
                child: Text(
                  'Search',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 44,
                      color: CustomColors().black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                height: boolsearch_height?300:100,
                child:  searchBar(isPortrait),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  'Category',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              listData == []
                  ? Container(height:MediaQuery.of(context).size.height,child: customProgressIndicator(),)
                  : gridWidgetDashboard(width, context, listData),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar(isPortrait){
    return FloatingSearchBar(
        hint: 'Search...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: MediaQuery.of(context).size.width,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          // Call your model, bloc, controller here.
          // setState(() {
          //   boolsearch_height=true;
          // });
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  boolsearch_height=false;
                });
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        backdropColor: CustomColors().white,
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Colors.accents.map((color) {
                  return Container(height: 112, color: color);
                }).toList(),
              ),
            ),
          );
        }
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
          onPressed: () {
            Navigator.push(
              context!,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
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
