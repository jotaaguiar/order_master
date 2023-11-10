import 'package:flutter/material.dart';

class TelaFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 102, 214, 10), Color.fromARGB(255, 190, 0, 0)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 100,
                color: Colors.yellow,
              ),
              SizedBox(height: 16.0),
              Text(
                '',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.0),
              // Adicione outros widgets aqui
            ],
          ),
        ),
      ),
    );
  }
}
