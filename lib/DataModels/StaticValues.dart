class StaticValues{
  static String userName='', userSurname='', employeeNumber='', occupation='',
   userDisplayPicture = '', backgroundImage='', email , pin  , question1 ='',
      question2='', question3='' , answer1='' , answer2='', answer3='';
  static int Age =0;
  static bool bio = true;

  static splitEmailForFirebase(String email){
    List full = email.split('.');
    String replacedEmail ='';
    for (int i = 0 ; i < full.length; i++){
      if(i == 0){
        replacedEmail = replacedEmail + full[i];
      }else {
        replacedEmail = replacedEmail + '*PERIOD_REPLACEMENT*' + full[i];
      }
    }
    return replacedEmail;
  }

  static splitFromFirebase(String email){
    List full = email.split('*PERIOD_REPLACEMENT*');
    String originalEmail = '';
    for(int i = 0; i < full.length; i++){
      originalEmail = originalEmail + '.' + full[i];
    }

    return originalEmail;
  }
}