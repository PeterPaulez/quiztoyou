import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiztoyou/services/auth.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  void _signOut() async {
    try {
      await auth.signOut();
      print('LogOUT');
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> render(BuildContext context, List children) {
    return ListTile.divideTiles(
        context: context,
        tiles: children.map((dynamic data) {
          return buildListTile(context, data[0], data[1], data[2]);
        })).toList();
  }

  Widget buildListTile(
      BuildContext context, String title, String subtitle, String url) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(url);
      },
      isThreeLine: true,
      dense: false,
      leading: null,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(
        Icons.arrow_right,
        color: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    //final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: _signOut,
          ),
        ],
        title: Column(
          children: [
            Text('Home Page'),
            Text(
              '${_user?.uid}',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
            width: 300,
            height: 500,
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.black,
              child: Swiper(
                index: 0,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    "https://via.placeholder.com/300x500",
                    fit: BoxFit.fill,
                  );
                },
                //autoplay: true,
                itemCount: 10,
                scrollDirection: Axis.vertical,
                pagination: SwiperPagination(alignment: Alignment.centerRight),
                control: SwiperControl(),
              ),
            )),
      ),
    );
  }
}
