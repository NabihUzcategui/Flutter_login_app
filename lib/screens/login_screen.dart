import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/login_form_provider.dart';
import '../ui/input_decarations.dart';
import 'package:productos_app/widgtes/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 250),

              CardContainer(
                child: Column(
                  children: [

                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),                  
                    const SizedBox(height: 10),

                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  
                  ]
                ),
              ),

              const SizedBox(height: 50,),
              const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 50,),
            ],
          ),
        )
      ),
    );
  }
}



//Formulario de la card
class _LoginForm extends StatelessWidget {


  @override
  Widget build(BuildContext context) { 


    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      child: Column(
        children: [

          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecarations.authInputDecoration(
              hintText: 'escriba su dirección de correo', 
              labelText: 'Correo electónico',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
              ? null
              : 'El correo no es valido';
            },
          ),

          const SizedBox(height: 30),

          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecarations.authInputDecoration(
              hintText: '********', 
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_clock_outlined
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              
              return ( value != null && value.length >= 6) 
              ? null
              : 'La contraseña debe tener al mneos seis carateres';
              
            },
          ),

          const SizedBox(height: 30),


          MaterialButton(
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
            onPressed: loginForm.isLoading ? null : () async {

              FocusScope.of(context).unfocus();

              if( !loginForm.isValidForm() ) return;

              loginForm.isLoading = true;

              await Future.delayed(const Duration(seconds: 4));

              loginForm.isLoading = false;
              
              Navigator.pushReplacementNamed(context, 'home');
              
            },
              child: Container(
                padding: const  EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere...'
                  : 'Ingresar',
                  style: const  TextStyle(color: Colors.white)
                ),
              ),
          )

        ],

      )
    );
  }
}