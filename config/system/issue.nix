{ config, lib, ... }:

{
  environment.etc."issue" = {
    text = ''

       This is \l on \n.\o (\s \m \r)

       This system is for authorized users only. Individual use of this computer
       system and/or network without authority, or in excess of your authority,
       is strictly prohibited. Monitoring of transmissions or transactional
       information may be conducted to ensure the proper functioning and security
       of electronic communication resources. Anyone using this system expressly
       consents to such monitoring and is advised that if such monitoring reveals
       possible criminal activity or policy violation, system personnel may
       provide the evidence of such monitoring to law enforcement or to other
       senior officials for disciplinary action.


    '';
  };

  environment.etc."issue.plaintext" = {
    text = ''

       This system is for authorized users only. Individual use of this computer
       system and/or network without authority, or in excess of your authority,
       is strictly prohibited. Monitoring of transmissions or transactional
       information may be conducted to ensure the proper functioning and security
       of electronic communication resources. Anyone using this system expressly
       consents to such monitoring and is advised that if such monitoring reveals
       possible criminal activity or policy violation, system personnel may
       provide the evidence of such monitoring to law enforcement or to other
       senior officials for disciplinary action.


    '';
  };
}
