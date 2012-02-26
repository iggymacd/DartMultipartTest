class MultipartForm {
  MultipartForm(){
  }
  void parse(HTTPRequest req, Function cb){
    
    req.dataReceived = (List<int> data){
      data.forEach((value){
        print('value is $value');
      });
    };
    req.dataEnd = (){
      print('dataEnd ...');
      cb('one', 'two', 'three');
    };

  }
}
