// import 'package:lestiterakhir/app/models/user_model.dart';
// import 'package:vania/vania.dart';

// class UserController extends Controller {
//   Future<Response> index() async {
//     Map? user = Auth().user();

//     user?.remove('password');
//     return Response.json({
//       'status': 'success',
//       'message': 'Data pengguna berhasil diambil',
//       'data': user,
//     });
//   }

//   Future<Response> updatePassword(Request request) async {
//     request.validate({
//       'current_password': 'required',
//       'password': 'required|min_length:6|confirmed'
//     }, {
//       'current_password.required': 'Password saat ini wajib diisi',
//       'password.required': 'Password baru wajib diisi',
//       'password.min_length': 'Password baru harus memiliki minimal 6 karakter',
//       'password.confirmed': 'Konfirmasi password tidak cocok',
//     });

//     String currentPassword = request.string('current_password');

//     Map<String, dynamic>? user = Auth().user();

//     if (Hash().verify(currentPassword, user?['password'])) {
//       await User().query().where('id', '=', Auth().id()).update({
//         'password': Hash().make(request.string('password')),
//       });
//       return Response.json({
//         'status': 'success',
//         'message': 'Password berhasil diperbarui',
//       });
//     } else {
//       return Response.json({
//         'status': 'error',
//         'message': 'Password saat ini tidak cocok',
//       }, 401);
//     }
//   }

//   Future<Response> create() async {
//     return Response.json({});
//   }

//   Future<Response> store(Request request) async {
//     return Response.json({});
//   }

//   Future<Response> show(int id) async {
//     return Response.json({});
//   }

//   Future<Response> edit(int id) async {
//     return Response.json({});
//   }

//   Future<Response> update(Request request, int id) async {
//     return Response.json({});
//   }

//   Future<Response> destroy(int id) async {
//     return Response.json({});
//   }
// }

// final UserController userController = UserController();
