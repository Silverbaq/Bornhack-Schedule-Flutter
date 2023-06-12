import 'package:bornhack/business_logic/media_archive/media_archive.api.dart';
import 'package:bornhack/business_logic/media_archive/model/File.dart';
import 'package:pmvvm/view_model.dart';

class MediaArchiveViewModel extends ViewModel {
  var mediaApi = MediaApi();
  String mediaUrl = 'https://mediastaging.bornhack.org';

  List<File> files = <File>[];

  @override
  void init() async {
    super.init();

    files = await mediaApi.getFiles();
    notifyListeners();



    //var file = await mediaApi.getFile('7287ceb2-29b0-40af-8b6d-a616c746be56');
    //var s = "";
  }
}