import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Calendario extends StatefulWidget {
  const Calendario({super.key, required this.uid});

  final String? uid;

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<Calendario> {
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('habitos')
        .doc(widget.uid).collection('habitos')
        .get();

    _appointments.clear();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      final data = document.data() as Map<String, dynamic>;
      final startDate = data['fechaInicial'].toDate();
      final endDate = data['fechaFinal'].toDate();

      final color = Color.fromARGB(
        255,
        data['color'][1],
        data['color'][2],
        data['color'][3],
      );

      _appointments.add(Appointment(
        startTime: startDate,
        endTime: endDate,
        subject: 'My Event',
        color: color,
      ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        backgroundColor: Theme.of(context).colorScheme.onSecondaryFixed.withAlpha(150),
        view: CalendarView.month,
        dataSource: MyCalendarDataSource(_appointments),
      ),
    );
  }
}



class MyCalendarDataSource extends CalendarDataSource {
  MyCalendarDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}