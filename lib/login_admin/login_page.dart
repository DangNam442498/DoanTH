import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/auth/auth.dart';
import 'package:recipes_app/model/user_model.dart';

import 'menu_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignIn});

  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, registro }
enum SelectSource { camara, galeria }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  //Declaramos las variables
  String _email;
  String _password;
  String _name;
  String _phone;
  String _address;
  String _direction;
  String _urlphoto = '';
  String user;

  bool _obscureText = true;
  FormType _formType = FormType.login;
  List<DropdownMenuItem<String>> _lsaddress; //list city from Firestore

  @override
  void initState() {
    super.initState();
    setState(() {
      _lsaddress = getCiudadItems();
      _address = _lsaddress[0].value;
    });
  }

  getData() async {
    return await Firestore.instance.collection('city').getDocuments();
  }

  //Dropdownlist from firestore
  List<DropdownMenuItem<String>> getCiudadItems() {
    List<DropdownMenuItem<String>> items = List();
    QuerySnapshot dataCiudades;
    getData().then((data) {
      dataCiudades = data;
      dataCiudades.documents.forEach((obj) {
        print('${obj.documentID} ${obj['nombre']}');
        items.add(DropdownMenuItem(
          value: obj.documentID,
          child: Text(obj['nombre']),
        ));
      });
    }).catchError((error) => print('Có lỗi' + error));

    items.add(DropdownMenuItem(
      value: '0',
      child: Text('- Lựa chọn -'),
    ));

    return items;
  }

  bool _validarGuardar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //we create a method validate and send
  void _validarEnviar() async {
    if (_validarGuardar()) {
      try {
        String userId =
            await widget.auth.signInEmailPassword(_email, _password);
        print('Người dùng đăng nhập với Id : $userId '); //ok
        widget.onSignIn();
        HomePage(auth: widget.auth); //return menu_page.dart
        Navigator.of(context).pop();
      } catch (e) {
        print('Lỗi .... $e');
        AlertDialog alerta = new AlertDialog(
          content: Text('Xác thực tài khoản thất bại'),
          title: Text('Lỗi'),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alerta);
      }
    }
  }

  //Xác thực đăng ký
  void _validarRegistrar() async {
    if (_validarGuardar()) {
      try {
        User user = User(
            //model/user_model.dart instance usuario
            name: _name,
            address: _address,
            direction: _direction,
            email: _email,
            password: _password,
            phone: _phone,
            photo: _urlphoto);
        String userId = await widget.auth.signUpEmailPassword(user);
        print('Người dùng đăng nhập : $userId'); //ok
        widget.onSignIn();
        HomePage(auth: widget.auth); //menu_page.dart
        Navigator.of(context).pop();
      } catch (e) {
        print('Lỗi .... $e');
        AlertDialog alerta = new AlertDialog(
          content: Text('Đăng ký thất bại'),
          title: Text('Lỗi'),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alerta);
      }
    }
  }

  //method go register
  void _irRegistro() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.registro;
    });
  }

  //method go Login
  void _irLogin() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                  child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .stretch, //ajusta los widgets a lso extremos
                    children: [
                          Text(
                            'Thông tin \n Tài khoản',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 15.0)),
                          Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        ] +
                        buildInputs() +
                        buildSubmitButtons()),
              )))),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        //list or array
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) =>
              value.isEmpty ? 'Nhập địa chỉ Email hợp lệ' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: _obscureText,
          decoration: InputDecoration(
              labelText: 'Mật khẩu',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          validator: (value) => value.isEmpty
              ? 'Trường mật khẩu phải có ít nhất 6 ký tự'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ];
    } else {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Text(
          'Đăng kí người dùng',
          style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Tên', icon: Icon(FontAwesomeIcons.user)),
          validator: (value) =>
              value.isEmpty ? 'Tên trống' : null,
          onSaved: (value) => _name = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Điện thoại di động',
            icon: Icon(FontAwesomeIcons.phone),
          ),
          validator: (value) =>
              value.isEmpty ? 'Điện thoại không được để trống' : null,
          onSaved: (value) => _phone = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        DropdownButtonFormField(
          validator: (value) =>
              value == '0' ? 'Bạn phải chọn một thành phố' : null,
          decoration: InputDecoration(
              labelText: 'Thành phố', icon: Icon(FontAwesomeIcons.city)),
          value: _address,
          items: _lsaddress,
          onChanged: (value) {
            setState(() {
              _address = value;
            });
          }, //seleccionarCiudadItem,
          onSaved: (value) => _address = value,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Phương hướng',
              icon: Icon(Icons.person_pin_circle),
            ),
            validator: (value) => value.isEmpty ? 'Địa chỉ không được để trống' : null,
            onSaved: (value) => _direction = value.trim()),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) => value.isEmpty ? 'Email không được để trống' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          obscureText: _obscureText, //password
          decoration: InputDecoration(
              labelText: 'Mật khẩu',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          validator: (value) =>
              value.isEmpty ? 'Mật khẩu phải có ít nhất 6 ký tự' : null,
          onSaved: (value) => _password = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: _validarEnviar,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Đồng ý nhập",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.white,
              )
            ],
          ),
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 8.0,
        ),
        FlatButton(
          child: Text(
            'Tạo mới', //create new acount
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
          onPressed: _irRegistro,
        ),
      ];
    } else {
      return [
        RaisedButton(
          onPressed: _validarRegistrar,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Tạo mới tài khoản", //register new acount
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Icon(
                FontAwesomeIcons.plusCircle,
                color: Colors.white,
              )
            ],
          ),
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 8.0,
        ),
        FlatButton(
          child: Text(
            'Bạn chưa có Tài khoản?',
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
          onPressed: _irLogin,
        )
      ];
    }
  }
}
