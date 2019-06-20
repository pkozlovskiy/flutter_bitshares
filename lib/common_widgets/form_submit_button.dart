import 'package:flutter/material.dart';
import 'package:flutter_bitshares/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          textColor: Colors.black87,
          borderRadius: 4.0,
          loading: loading,
          onPressed: onPressed,
        );
}