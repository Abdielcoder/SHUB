import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 350),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/img/circulolavador.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Voitu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                NewRow(
                  text: 'Editar perfil',
                  icon: Icons.account_circle,
                ),
                SizedBox(
                  height: 20,
                ),
                NewRow(
                  text: 'Vehículos',
                  icon: Icons.directions_car,
                ),
                SizedBox(
                  height: 20,
                ),
                NewRow(
                  text: 'Mis servicios',
                  icon: Icons.domain_verification_sharp,
                ),
                SizedBox(
                  height: 20,
                ),
                NewRow(
                  text: 'Métodos de pago',
                  icon: Icons.add_card,
                ),
                SizedBox(
                  height: 20,
                ),

              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Cerrar sesion',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const NewRow({
    Key key,
    this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}