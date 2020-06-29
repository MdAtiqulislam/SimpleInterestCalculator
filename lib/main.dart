import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple interest calculator app",
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
    ),
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.indigo, // navigation bar color
    //statusBarColor: Colors.pink, // status bar color
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {

  var _formKey=GlobalKey<FormState>();
  var _currencies = ['Taka', 'Dollers', 'Pounds'];
  final _minimumPadding = 5.0;
  var _currentSelected = '';
  TextEditingController principleController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  var displayResult = '';

  @override
  void initState() {
    super.initState();
    _currentSelected = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(title: Text("Simple Interest Calculator")),
      body: Form(
        key: _formKey,
          child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
            child: Center(
              child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: principleController,
                    validator: (String value){
                      if(value.isEmpty){
                        return "Please Enter Principle Amount";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Principal',
                        hintText: 'Enter principal',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(color: Colors.yellowAccent,fontSize:15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: roiController,
                      validator: (String value){
                        if(value.isEmpty){
                          return "Please Enter Rate of Interest";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Rate of interest',
                          hintText: 'In percent',
                          errorStyle: TextStyle(color: Colors.yellowAccent,fontSize:15.0),
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        controller: termController,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Please enter Time in Year";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Term',
                            hintText: 'Time in year',
                            errorStyle: TextStyle(color: Colors.yellowAccent,fontSize:15.0),
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: textStyle,
                              ),
                            );
                          }).toList(),
                          value: _currentSelected,
                          onChanged: (String newValueSelected) {
                            _onDropDownItenSelected(newValueSelected);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              if(_formKey.currentState.validate()) {
                                this.displayResult = _calculateTotalReturns();
                              }
                            });
                          },
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            "calculate",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Reset",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                )
              ],
            ),
          ),
      )),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 2),
    );
  }

  void _onDropDownItenSelected(String newValueSelected) {
    setState(() {
      this._currentSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principle = double.parse(principleController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);
    double totalAmountPayable = principle + (principle * roi * term) / 100;

    String result =
        'After $term years, you will be worth $totalAmountPayable $_currentSelected';
    return result;
  }

  void _reset() {
    principleController.text = "";
    roiController.text = "";
    termController.text = "";
    displayResult = "";
    _currentSelected = _currencies[0];
  }
}
