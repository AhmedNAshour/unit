import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unit/models/user.dart';
import 'package:unit/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from Firebase User
  MyUser _userFromFirbaseUser(User user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirbaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return _userFromFirbaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future createUserWithEmailAndPasword(
      String email, password, name, phoneNumber, gender, role, picURL) async {
    FirebaseApp tempApp = await Firebase.initializeApp(
        name: 'temporaryregister', options: Firebase.app().options);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: tempApp)
              .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      // create new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
        name: name,
        phoneNumber: phoneNumber,
        gender: gender,
        role: role,
        password: password,
        email: email,
        picURL: '',
        likes: [],
      );
      await tempApp.delete();
      return Future.sync(() => _userFromFirbaseUser(user));
    } catch (e) {
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPasword(
      String email, password, name, phoneNumber, gender, role, picUrl) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      // create new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
        name: name,
        phoneNumber: phoneNumber,
        gender: gender,
        role: role,
        password: password,
        email: email,
        picURL: '',
        likes: [],
      );

      return _userFromFirbaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
