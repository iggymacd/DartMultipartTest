#library('multipart_test');
#import('../lib/testing/unittest/unittest_vm.dart');
#import('../multipart_library.dart');
#import('../lib/HTTP/http.dart');
#import('dart:io');

void main(){
  testMultipartForm();
}

//mock class for testing
class HTTPRequestMockImpl implements HTTPRequest{
  Function dataReceived;
  Function dataEnd;
  void invokeDataReceivedHandler(List<int> data) {
    if (dataReceived != null) {
      dataReceived(data);
    } 
  }
  void invokeDataEndHandler() {
    if (dataEnd != null) {
      dataEnd();
    } 
  }
}


testMultipartForm(){
  List<int> dataChunkOne = const [10,13,10,13];
  List<int> dataChunkTwo = const [13,10,13,10];
  HTTPRequestMockImpl req = new HTTPRequestMockImpl();
  MultipartForm form = new MultipartForm();
  asyncTest('MultipartForm ideal scenario',1, (){
    form.parse(req, (err, fields, files) {
      print('err is $err, fields is $fields, and files is $files');
      callbackDone();
      Expect.equals('one', err);
    });
    req.invokeDataReceivedHandler(dataChunkOne);
    req.invokeDataReceivedHandler(dataChunkTwo);
    req.invokeDataEndHandler();
  });

  req = new HTTPRequestMockImpl();
  form = new MultipartForm();
  String fileName = "./resources/test.dat";
  int result;
  int bytesRead;
  List<int> buffer = new List<int>();
  ChunkedInputStream x = new ChunkedInputStream((new File(fileName)).openInputStream());
  x.chunkSize = 1024;
  x.dataHandler = () {
    buffer.addAll(x.read());
    print('in dataHandler...${buffer.length}');
  };
  x.closeHandler = () {
      print('finished reading ${buffer.length} bytes.');
      bytesRead = buffer.length;
      //MultipartParser multipartParser = new MultipartParser();
      //multipartParser.boundary = '-------WebKitFormBoundaryrMpAWVGZS3EX1kAY';

      asyncTest('MultipartForm ideal scenario, from file',1, (){
        form.parse(req, (err, fields, files) {
          print('err is $err, fields is $fields, and files is $files');
          callbackDone();
          Expect.equals('one', err);
        });
        req.invokeDataReceivedHandler(buffer);
      //req.invokeDataReceivedHandler(dataChunkTwo);
        req.invokeDataEndHandler();
      });

      
      //result = multipartParser.write(buffer);
      //print('expected is $bytesRead');
      //print('result is $result');
  };

  
//  asyncTest('MultipartForm ideal scenario',1, (){
//    form.parse(req, (err, fields, files) {
//      print('err is $err, fields is $fields, and files is $files');
//      callbackDone();
//      Expect.equals('one', err);
//    });
//    req.invokeDataReceivedHandler(dataChunkOne);
//    req.invokeDataReceivedHandler(dataChunkTwo);
//    req.invokeDataEndHandler();
//  });
}
