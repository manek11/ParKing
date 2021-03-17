import 'package:flutter/material.dart';
import 'package:parking_app/assistant/requestAssistant.dart';
import 'package:parking_app/configMaps.dart';
import 'package:parking_app/models/address.dart';
import 'package:parking_app/models/placePredictions.dart';
import 'package:parking_app/widgets/Divider.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/DataHandler/appData.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController startPointTextEditingController = TextEditingController();
  TextEditingController endPointTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];


  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).startLocation.placeName ?? "";
    startPointTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Icon(
                            Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Set Destination", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),

                  Row(
                    children: [
                      Image.asset("assets/images/pin_location.png", height: 16.0, width: 16.0,),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: startPointTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Starting Point",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: [
                      Image.asset("assets/images/destination.png", height: 16.0, width: 16.0,),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              controller: endPointTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          //tile to display predictions
          SizedBox(height: 10.0,),
          (placePredictionList.length > 0) ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index){
                return PredictionTile(placePredictions: placePredictionList[index],);
              },
              separatorBuilder: (BuildContext context, int index) => DividerWidget(),
              itemCount: placePredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          ) : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async{
    if(placeName.length > 1){
      String autoCompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ca";

      var response = await RequestAssistant.getRequest(autoCompleteURL);

      if(response == "failed"){
        return;
      }
      // print("Places Prediction Response :: ");
      // print(response);

      if(response["status"] == "OK"){
        var predictions = response["predictions"];
        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }

    }
  }
}


class PredictionTile extends StatelessWidget {

  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0,),
                      Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(placePredictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),

      ),
    );
  }
  void getPlaceAddressDetails(String placeId, context) async{

    showDialog(
        context: context,
        builder: (BuildContext context) => Center(child: CircularProgressIndicator(),)//ProgressDialog(message: "Setting Destination, Please Wait...",),
    );

    String placeDetailsURL = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var response = await RequestAssistant.getRequest(placeDetailsURL);

    Navigator.pop(context);

    if(response == "failed"){
      return;
    }

    if(response["status"] == "OK"){
      Address address = Address();
      address.placeName = response["result"]["name"];
      address.placeId = placeId;
      address.latitude = response["result"]["geometry"]["location"]["lat"];
      address.longitude = response["result"]["geometry"]["location"]["lng"];

      //here i need to make request to nearest parking spot and return that as address along with other details
      double lat = address.latitude;
      double lng = address.longitude;

      showDialog(
          context: context,
          builder: (BuildContext context) => Center(child: CircularProgressIndicator(),)//ProgressDialog(message: "Setting Destination, Please Wait...",),
      );

      String parkingPlaceDetailsURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&rankby=distance&type=parking&key=$mapKey";
      var parking_response = await RequestAssistant.getRequest(parkingPlaceDetailsURL);

      Navigator.pop(context);

      if(parking_response == "failed"){
        return;
      }
      if(parking_response["status"] == "OK"){
        Address parking_address = Address();
        parking_address.placeName = parking_response["results"][0]["name"];
        parking_address.placeId = parking_response["results"][0]["place_id"];
        parking_address.latitude = parking_response["results"][0]["geometry"]["location"]["lat"];
        parking_address.longitude = parking_response["results"][0]["geometry"]["location"]["lng"];

        Provider.of<AppData>(context, listen: false).updatEndLocationAddress(parking_address);
        print("This is Parking Location ::");
        print(parking_address.placeName);

        Navigator.pop(context, "obtainDirection");
      }

    }
  }
}
