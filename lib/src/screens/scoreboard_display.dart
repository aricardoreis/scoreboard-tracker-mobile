import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ScoreBoardDisplay extends StatefulWidget {
  final String homeName;
  final String guestName;

  final int homeScore;
  final int guestScore;

  const ScoreBoardDisplay({
    super.key,
    required this.homeName,
    required this.guestName,
    this.homeScore = 0,
    this.guestScore = 0,
  });

  @override
  State<ScoreBoardDisplay> createState() => _ScoreBoardDisplayState();
}

class _ScoreBoardDisplayState extends State<ScoreBoardDisplay> {
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              renderTeamName(widget.homeName, backgroundColor: Colors.purple),
              renderScoreNumber(widget.homeScore),
            ],
          ),
          Column(
            children: [
              renderTeamName(widget.guestName, backgroundColor: Colors.blue),
              renderScoreNumber(widget.guestScore),
            ],
          )
        ],
      ),
    );
  }

  renderScoreNumber(int value, {Color backgroundColor = darkBlue}) {
    return Container(
      color: backgroundColor,
      width: _size.width * 0.45,
      height: _size.height * 0.9,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          formatScoreNumber(value),
          style: const TextStyle(
            color: liveYellow,
            fontFamily: 'Digital7',
          ),
        ),
      ),
    );
  }

  renderTeamName(String name, {Color backgroundColor = Colors.black}) {
    return Expanded(
      child: Container(
        color: backgroundColor,
        height: _size.height * 0.075,
        width: _size.width * 0.45,
        child: FittedBox(
          child: Text(
            name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  formatScoreNumber(int value) => value.toString().padLeft(2, ' ');
}
