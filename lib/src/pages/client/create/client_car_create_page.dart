import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber_clone_flutter/src/pages/client/create/client_car_create_controller.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:dropdown_search/dropdown_search.dart';


class CLientCarCreatePage extends StatefulWidget {
  const CLientCarCreatePage({Key key}) : super(key: key);

  @override
  _CLientCarCreatePageState createState() => _CLientCarCreatePageState();
}

class _CLientCarCreatePageState extends State<CLientCarCreatePage> {

  ClientCarCreateController _con = new ClientCarCreateController();
  //DEFAULT CAR COLOR
  Color currentColor = Colors.limeAccent;
  String dropdownValue = 'Año';
  //SET COLOR TO CURRENT COLOR
  //void changeColor(Color color) => setState(() => currentColor = color);
  void setStateColor(Color color){
    setState(() {
      currentColor = color;
      //_con.selectedCarColor =currentColor.toString();
      _con.onSelectedColor(currentColor.toString());
    });
  }
  @override
  void initState() {

    // TODO: implement initState
    super.initState();


    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(//BODY BACKGROUND COLOR
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue.shade900, Colors.cyan.shade900])
      ),
      child: Scaffold(
        //Bottom overflowed by x pixels when showing keyboard
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Agrega un auto'),
        ),
        body: Column(
          children: [
            _textImg(),
            _photoColorCar(),
            _marcaModelo(),
            _yearDescripcion(),
            _placa(),
            _changeColor(),
            _imageColorCar()
          ],

        ),


        bottomNavigationBar: _buttonCreate(),
      ),
    );
  }

  //TWO ELEMENTS
  Widget _marcaModelo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
         child: _textFieldMarca(),
        ),
        Expanded(
          child: _textFieldModelo(),
        ),

      ],
    );
  }

  Widget _yearDescripcion(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: _textFieldYear()
        )
      ],
    );
  }

  Widget _placa(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: _textFieldPlaca()
        )
      ],
    );
  }


  Widget _changeColor(){
    return Container(
      margin: EdgeInsets.only(top: 0,bottom:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: _color()
          )
        ],
      ),
    );
  }

  Widget _color(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            elevation: 1.0,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: currentColor,
                        onColorChanged: setStateColor,
                        colorPickerWidth: 300.0,
                        pickerAreaHeightPercent: 0.2,
                        enableAlpha: true,
                        displayThumbColor: true,
                        showLabel: true,
                        paletteType: PaletteType.hsv,
                        pickerAreaBorderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(2.0),
                          topRight: const Radius.circular(2.0),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text('Selecciona color',
            style: TextStyle(
              fontFamily: 'Lexendeca-Regular',
            ),),
            color: MyColors.primaryColor,
            textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _textImg() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          "Seleciona o toma una foto",
          style:  TextStyle(
          color: Colors.white,
          fontFamily: 'Lexendeca-Regular',
          )
        ),

    );
  }


  Widget _photoColorCar() {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: GestureDetector(
        onTap: _con.showAlertDialog,
        child: CircleAvatar(
          backgroundImage: _con.imageFile != null
              ? FileImage(_con.imageFile)
              : AssetImage('assets/img/pushf.png'),
          radius: 60,
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _imageColorCar() {
    return GestureDetector(
      onTap: (){},
      child: CircleAvatar(
        backgroundImage:
        AssetImage('assets/img/car_color.png'),
        radius: 50,
          backgroundColor: currentColor,

      ),
    );
  }


  Widget _textFieldMarca() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
        controller: _con.marcaController,
        decoration: InputDecoration(
            hintText: 'Marca',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark,
                fontFamily: 'Lexendeca-Black',
            ),
          suffixIcon:  Image.asset('assets/img/mcarro.png', width: 30, height: 30),
        ),
      ),
    );
  }

  Widget _textFieldYear() {

    return Container(

      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 179),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(30)
      ),
      child:DropdownSearch<String>(
        popupBackgroundColor: Colors.grey[200],
        mode: Mode.MENU,

        showSelectedItems: true,
          items: <String>['AÑO', '2022', '2021', '2020','2019','2018','2017','2016','2015'
          ,'2014','2013','2012','2011','2010','2009','2008','2007','2006','2005','2004',
          '2003','2002','2001','2000','1999','1998','1997','1996','1995','1994','1993',
            '1992','1991','1990','1989','1988','1987','1986','1985','1984','1983','1982',
          '1981','1980','1979','1978','1977','1976','1975','1974','1973','1972','1971',
          '1970','1969','1968','1967','1966','1965','1964','1963','1962','1961','1960',
          '1959','1958','1957','1956','1955','1954','1953','1952','1951','1950','OTRO'],

        dropdownSearchDecoration: InputDecoration(
        labelText: "Selecciona Año",
        hintText: "AÑo",

          fillColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
      ),

        onChanged: (String newValue) {
          setState(() {
            _con.onSelected(newValue);
            dropdownValue = newValue;
          });
        },
        selectedItem: "Año",
      )

        );
  }
  Widget _textFieldPlaca() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 160),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
        controller: _con.placaController,
        decoration: InputDecoration(
            hintText: 'Placa',

            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark,
              fontFamily: 'Lexendeca-Black',
            ),
          suffixIcon:  Image.asset('assets/img/car_plate.png', width: 30, height: 30),
        ),
      ),
    );
  }

  Widget _textFieldModelo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
        controller: _con.modeloController,
        decoration: InputDecoration(
            hintText: 'Modelo',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark,
              fontFamily: 'Lexendeca-Black',
            ),
            suffixIcon:  Image.asset('assets/img/brand.png', width: 20, height: 20),
        ),
      ),
    );
  }


  Widget _buttonCreate() {
    return Container(
      height:70,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 135, vertical: 40),
      child: ElevatedButton(
        onPressed: _con.createCar,
        child: Text('Agregar Auto',
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
          fontFamily: 'Lexendeca-Black',
        ),),
        style: ElevatedButton.styleFrom(

          onPrimary: Colors.black,
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 5),

        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }




}
