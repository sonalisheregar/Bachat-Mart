import 'package:flutter/material.dart';
import 'package:bachat_mart/controller/mutations/cart_mutation.dart';
import 'package:bachat_mart/controller/mutations/cat_and_product_mutation.dart';
import 'package:bachat_mart/models/VxModels/VxStore.dart';
import 'package:bachat_mart/models/newmodle/category_modle.dart';
import 'package:bachat_mart/repository/productandCategory/category_or_product.dart';
import 'package:velocity_x/velocity_x.dart';
import '../assets/ColorCodes.dart';
import '../screens/items_screen.dart';
import '../providers/categoryitems.dart';

import 'package:provider/provider.dart';

class ExpansionDrawer extends StatefulWidget {

  final String parentcatId;
  final  Function(String,int,int)? onclick;
  final String subcatID;

  // void Function(VoidCallback fn) state;
  ExpansionDrawer(this.parentcatId, this.subcatID,{this.onclick});

  @override
  _ExpansionDrawerState createState() => _ExpansionDrawerState();
}

class _ExpansionDrawerState extends State<ExpansionDrawer> {
  List variddata = [];
  var subcategoryData;
  var varlength;
  int selected = -1;
  final categoriesData = (VxState.store as GroceStore).homescreen.data!.allCategoryDetails;
  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   categoriesData = Provider.of<CategoriesItemsList>(context, listen: false);
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ProductController productController = ProductController();
    debugPrint("maincatidexpansion" + widget.parentcatId);
    debugPrint("subcatidexpansion" + widget.subcatID);

    if(categoriesData!.length>0)
      return Container(
        width: 200,
        height:MediaQuery.of(context).size.height,
        constraints: BoxConstraints(
          minHeight: 500,
          maxHeight:double.infinity,
          // maxWidth: 30.0,
        ),
        child: ListView.builder(
          key: Key('lbuilder ${selected.toString()}'),
          itemCount: categoriesData!.length,
          itemBuilder: (_, index) {
            // if(index>0)
            // productController.geSubtCategory(categoriesData[index].id);
            debugPrint("building........"+categoriesData![index].parentId.toString()+"..."+categoriesData![index].id.toString());
            return ListTileTheme(
                key: Key(index.toString()),
                contentPadding: EdgeInsets.all(0),
                child: ExpansionTile(

                    onExpansionChanged: (val){
                      if (val)
                        setState(() {
                          Duration(seconds: 20000);
                          selected = index;
                        });
                      else
                        setState(() {
                          selected = -1;
                        });
                    },
                    initiallyExpanded: selected<0?(widget.parentcatId == categoriesData![index].id):index==selected,
                    title: Text(categoriesData![index].categoryName!),
                    children: [
                      if(widget.subcatID!=null&& widget.parentcatId!=null) SubCategoriesGrid(categoriesData![index],widget.subcatID,widget.parentcatId,widget.onclick!),
                    ]
                ));
          },
        ),
      );
    else
      return CircularProgressIndicator();
  }

}
//subNested
class SubCategoriesGrid extends StatefulWidget {
  CategoryData categoriesData ;
  String subcatID;
  String parentId;
  Function(String,int,int) onclick;

  SubCategoriesGrid(this.categoriesData, this.subcatID, this.parentId,this.onclick);

  @override
  _SubCategoriesGridState createState() => _SubCategoriesGridState();
}

class _SubCategoriesGridState extends State<SubCategoriesGrid> {

  // CategoriesItemsList subcategoryData;
  var _isloading = true;

  int higliteindex = 0;
  int selectedsub = -1;
  @override
  void initState() {
    // Provider.of<CategoriesItemsList>(context, listen: false)
    //     .fetchNestedCategory(widget.catId,"subitemScreen")
    //     .then((_) {
    //   setState(() {
    //     subcategoryData = Provider.of<CategoriesItemsList>(
    //       context,
    //       listen: false,
    //     );
    //     _isloading = subcategoryData.itemsubNested.isEmpty? true:!true;
    //   });
    // });
    // TODO: implement initState
    higliteindex = widget.categoriesData.subCategory.indexWhere((element) => element.id==widget.subcatID);
    selectedsub = widget.categoriesData.subCategory.indexWhere((element) => element.id==widget.subcatID);
    debugPrint("sss,,,,"+higliteindex.toString()+",,"+selectedsub.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    );*/
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 768) {
      widgetsInRow = 4;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }

    return  Column(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            //color: Colors.white,
          ),

          child: /*_isloading? Center(
            child: CircularProgressIndicator(),
          ) :*/
          widget.categoriesData.subCategory .length<=1?Padding(
            padding: EdgeInsets.only(bottom: 10),
            child:  Text("No Item Found",),
          ):
          ListView.builder(
              shrinkWrap: true,
              controller: new ScrollController(keepScrollOffset: false),
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              itemCount: widget.categoriesData.subCategory.length,
              itemBuilder: (ctx, i) {
                return ListTileTheme(
                    key: Key(i.toString()),
                    contentPadding: EdgeInsets.all(0),
                    child: ExpansionTile(

                        onExpansionChanged: (val){
                          if (val)
                            setState(() {
                              Duration(seconds: 20000);
                              selectedsub = i;
                            });
                          else
                            setState(() {
                              selectedsub = -1;
                            });
                        },
                        initiallyExpanded: selectedsub<0?(widget.parentId == widget.categoriesData.subCategory[i].id):i==selectedsub,
                        title: Text(widget.categoriesData.subCategory[i].categoryName!),
                        children: [
                          if(widget.subcatID!=null) NestCategoriesGrid(widget.categoriesData.subCategory[i],widget.subcatID,widget.onclick),
                        ]
                    ));
                /*GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    higliteindex = i;
                  });
                  widget.onclick(widget.categoriesData.subCategory[i].id!,
                      widget.categoriesData.subCategory[i].type!, i);
                  // print("clickforid: "+{
                  //   'maincategory':  widget.categoriesData.categoryName,
                  //   'catId':  widget.categoriesData.id,
                  //   'catTitle':  widget.categoriesData.categoryName,
                  //   'subcatId': widget.categoriesData.subCategory[i].id,
                  //   'indexvalue': i.toString(),
                  //   'type': widget.categoriesData.subCategory[i].type.toString(),
                  //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                  //   'prev': "category_item"}.toString());
                  // Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                  //   'maincategory': widget.categoriesData.categoryName,
                  //   'catId': widget.categoriesData.id,
                  //   'catTitle': widget.categoriesData.categoryName,
                  //   'subcatId': widget.categoriesData.subCategory[i].id,
                  //   'indexvalue': i.toString(),
                  //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                  //   'prev': "category_item"});
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.categoriesData.subCategory[i].categoryName!,
                    style: TextStyle(
                        color: (i == higliteindex)
                            ? ColorCodes.discount
                            : Colors.black
                    ),
                  ),
                ),
              );*/
              }
          ),
        )
      ],
    );
  }
}


//Nested......
class NestCategoriesGrid extends StatefulWidget {
  CategoryData categoriesData ;
  String subcatID;
  Function(String,int,int) onclick;

  NestCategoriesGrid(this.categoriesData, this.subcatID, this.onclick);

  @override
  _NestCategoriesGridState createState() => _NestCategoriesGridState();
}

class _NestCategoriesGridState extends State<NestCategoriesGrid> {

  // CategoriesItemsList subcategoryData;
  var _isloading = true;
  Future<List<CategoryData>>? _futureNestitem ;

  int higliteindex = 0;
  @override
  void initState() {
    // Provider.of<CategoriesItemsList>(context, listen: false)
    //     .fetchNestedCategory(widget.catId,"subitemScreen")
    //     .then((_) {
    //   setState(() {
    //     subcategoryData = Provider.of<CategoriesItemsList>(
    //       context,
    //       listen: false,
    //     );
    //     _isloading = subcategoryData.itemsubNested.isEmpty? true:!true;
    //   });
    // });
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      ProductRepo().getSubNestcategory(widget.subcatID.toString()).then((value) {
        setState(() {
          _futureNestitem = Future.value(value);
          debugPrint(_futureNestitem.toString());
        });
      });
    });
    higliteindex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  subcategoryData = Provider.of<CategoriesItemsList>(
      context,
      listen: false,
    );*/
    double deviceWidth = MediaQuery.of(context).size.width;
    int widgetsInRow = 3;
    double aspectRatio =
        (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 125;

    if (deviceWidth > 1200) {
      widgetsInRow = 5;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 295;
    } else if (deviceWidth > 768) {
      widgetsInRow = 4;
      aspectRatio =
          (deviceWidth - (20 + ((widgetsInRow - 1) * 10))) / widgetsInRow / 195;
    }

    return  Column(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            //color: Colors.white,
          ),

          child: /*_isloading? Center(
            child: CircularProgressIndicator(),
          ) :*/
        /*  widget.categoriesData.subCategory .length<=1?*/
          FutureBuilder(
              future: /*{ProductMutation}*/_futureNestitem,
              builder: (BuildContext context, AsyncSnapshot<List<CategoryData>> snapshot) {

                  return  (snapshot.data != null) ?ListView.builder(
                      shrinkWrap: true,
                      controller: new ScrollController(keepScrollOffset: false),
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                      itemCount: /*widget.categoriesData.subCategory.length*/snapshot
                          .data!.length,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              higliteindex = i;
                            });
                            widget.onclick(snapshot.data![i].id!,
                                snapshot.data![i].type!, i);
                            // print("clickforid: "+{
                            //   'maincategory':  widget.categoriesData.categoryName,
                            //   'catId':  widget.categoriesData.id,
                            //   'catTitle':  widget.categoriesData.categoryName,
                            //   'subcatId': widget.categoriesData.subCategory[i].id,
                            //   'indexvalue': i.toString(),
                            //   'type': widget.categoriesData.subCategory[i].type.toString(),
                            //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                            //   'prev': "category_item"}.toString());
                            // Navigator.of(context).pushReplacementNamed(ItemsScreen.routeName, arguments: {
                            //   'maincategory': widget.categoriesData.categoryName,
                            //   'catId': widget.categoriesData.id,
                            //   'catTitle': widget.categoriesData.categoryName,
                            //   'subcatId': widget.categoriesData.subCategory[i].id,
                            //   'indexvalue': i.toString(),
                            //   'subcattitle':widget.categoriesData.subCategory[i].categoryName,
                            //   'prev': "category_item"});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              snapshot.data![i].categoryName!,
                              style: TextStyle(
                                  color: (i == higliteindex) ? ColorCodes
                                      .discount : Colors.black
                              ),
                            ),
                          ),
                        );
                      }
                  ):Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child:  Text("No Item Found",),
                  );
              }
          ),
        ),
      ],
    );
  }
}