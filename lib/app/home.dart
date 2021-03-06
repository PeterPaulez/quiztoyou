import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/models/character.dart';
import 'package:quiztoyou/services/albumFlow/flow.dart';
import 'package:quiztoyou/services/auth.dart';
import 'package:quiztoyou/services/cardSwiper/card_swiper.dart';

class HomePage extends StatelessWidget {
  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      print('LogOUT');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await TextDialog.alert(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      textOK: 'Logout',
      textNOK: 'Cancel',
    );
    print('Hello: $didRequestSignOut');
    if (didRequestSignOut == true) {
      print('Hello');
      _signOut(context);
    }
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
            onPressed: () => _confirmSignOut(context),
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
        child: AlbumFlowPage(),
      ),
    );
  }

  Container cardsView() {
    return Container(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(2),
          //color: Colors.black,
          child: Swiper(
            layout: SwiperLayout.STACK,
            itemWidth: 300,
            itemHeight: 700,
            index: 0,
            itemBuilder: (BuildContext context, int index) {
              final Character character = characters[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  color: Color(character.color),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 30, 5, 10),
                        child: Text(
                          '${index + 1}. ${character.title}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Image.asset(character.avatar),
                        height: 500,
                      ),
                    ],
                  ),
                ),
              );
            },
            //autoplay: true,
            itemCount: characters.length,
            //scrollDirection: Axis.vertical,
            //pagination: SwiperPagination(alignment: Alignment.centerRight),
            //control: SwiperControl(),
          ),
        ));
  }
}
