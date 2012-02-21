#library('multipart_test');
#import('../lib/testing/unittest/unittest_vm.dart');
#import('../multipart_library.dart');
#import('../lib/HTTP/http.dart');

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

List<int> dataChunkOne = const [10,13,10,13];
List<int> dataChunkTwo = const [13,10,13,10];

testMultipartForm(){
  HTTPRequestMockImpl req = new HTTPRequestMockImpl();
  MultipartForm form = new MultipartForm();
  asyncTest('MultipartForm ideal scenario',1, (){
    form.parse(req, (err, fields, files) {
      print('err is $err, fields is $fields, and files is $files');
      callbackDone();
      Expect.equals('ones', err);
    });
    req.invokeDataReceivedHandler(dataChunkOne);
    req.invokeDataReceivedHandler(dataChunkTwo);
    req.invokeDataEndHandler();
  });
}
