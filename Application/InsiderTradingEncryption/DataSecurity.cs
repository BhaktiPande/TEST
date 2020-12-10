using System;
using System.Text;
using System.Security.Cryptography;
using System.Security.Permissions;
using System.Configuration;

namespace InsiderTradingEncryption
{
    /// <summary>
    /// This class facilitates encryption and decrypt of data using Rijndael algorithm
    /// </summary>
    public class DataSecurity : IDisposable
    {
        public DataSecurity()
        {

        }

        /// <summary>
        /// Encrypts data using "Rijndael" symmetric algorithm.
        /// </summary>
        /// <param name="i_sData">Data to be encrypted</param>
        /// <param name="i_sKey">Key to be used to encrypt the data</param>
        /// <param name="o_sEncryptedData">Encrypted data value</param>
        /// <returns>
        /// true = Success
        /// false = failure
        /// </returns>
        public bool SymmetricEncryption(string i_sData, string i_sKey, out string o_sEncryptedData)
        {
            // Hardcoded encryption key and IV. Same key and IV will be used for decrypting the message.
            //byte[] btIV = { 152, 22, 132, 65, 212, 143, 221, 17, 09, 92, 182, 169, 201, 121, 176, 01 };
            //string sVal = "Rgt3wkYs2GFueht5syHQ64wels9gtFSD"; // DB Key
            byte[] btIV = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
            byte[] btKey = Encoding.ASCII.GetBytes(i_sKey.ToCharArray());

            bool bStatus = false;
            string sEncryptedMessage = "";

            try
            {
                SymmetricAlgorithm oSA = SymmetricAlgorithm.Create("Rijndael");
                oSA.Key = btKey;
                oSA.IV = btIV;
                oSA.Mode = CipherMode.ECB;

                // Encode to byte array.
                byte[] PlainBytes = Encoding.ASCII.GetBytes(i_sData);

                // Create encryptor
                ICryptoTransform encryptor = oSA.CreateEncryptor();

                // Do encryption
                byte[] CipherBytes = encryptor.TransformFinalBlock(PlainBytes, 0, PlainBytes.Length);

                sEncryptedMessage = Convert.ToBase64String(CipherBytes);

                oSA.Clear();

                bStatus = true;
            }
            catch (Exception exp)
            {
                sEncryptedMessage = "";
                bStatus = false;

                //AppException ex = new AppException("Error while encrypting the data.", exp);
                //throw ex;
                throw exp;
            }
            finally
            {
                o_sEncryptedData = sEncryptedMessage;
            }

            return bStatus;
        }

        /// <summary>
        /// Encrypts data using "Rijndael" symmetric algorithm.
        /// </summary>
        /// <param name="i_sData">Data to be encrypted</param>
        /// <param name="o_sEncryptedData">Encrypted data value</param>
        /// <returns>
        /// true = Success
        /// false = failure
        /// </returns>
        public bool SymmetricEncryption(string i_sData, out string o_sEncryptedData)
        {
            // Hardcoded encryption key and IV. Same key and IV will be used for decrypting the message.
            string sVal = "Ps46klO0argt3mqY7FuwHt9zHQjv64LX";
            byte[] btIV = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
            byte[] btKey = Encoding.ASCII.GetBytes(sVal.ToCharArray());

            bool bStatus = false;
            string sEncryptedMessage = "";

            try
            {
                SymmetricAlgorithm oSA = SymmetricAlgorithm.Create("Rijndael");
                oSA.Key = btKey;
                oSA.IV = btIV;
                oSA.Mode = CipherMode.ECB;

                // Encode to byte array.
                byte[] PlainBytes = Encoding.ASCII.GetBytes(i_sData);

                // Create encryptor
                ICryptoTransform encryptor = oSA.CreateEncryptor();

                // Do encryption
                byte[] CipherBytes = encryptor.TransformFinalBlock(PlainBytes, 0, PlainBytes.Length);

                sEncryptedMessage = Convert.ToBase64String(CipherBytes);

                oSA.Clear();

                bStatus = true;
            }
            catch (Exception exp)
            {
                sEncryptedMessage = "";
                bStatus = false;

                //AppException ex = new AppException("Error while encrypting the data.", exp);
                throw exp;
            }
            finally
            {
                o_sEncryptedData = sEncryptedMessage;
            }

            return bStatus;
        }

        /// <summary>
        /// Decrypts the data using "Rijndael" symmetric algorithm.
        /// </summary>
        /// <param name="i_sData">Encrypted data that is to be decrypted</param>
        /// <param name="i_sKey">Key to be used to decrypt the data</param>
        /// <param name="o_sDecryptedData">Decrypted data value</param>
        /// <returns>
        /// true = Success
        /// false = Failure
        /// </returns>
        public bool SymmetricDecryption(string i_sData, string i_sKey, out string o_sDecryptedData)
        {
            // Hardcoded decryption key and IV. Same key and IV are used for encrypting the message.
            byte[] btIV = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
            byte[] btKey = Encoding.ASCII.GetBytes(i_sKey.ToCharArray());

            bool bStatus = false;
            string sDecodedMessage = "";

            if (i_sData == "")
            {
                bStatus = true;
                o_sDecryptedData = sDecodedMessage;

                return bStatus;
            }

            try
            {
                SymmetricAlgorithm oSA = SymmetricAlgorithm.Create("Rijndael");
                oSA.Key = btKey;
                oSA.IV = btIV;
                oSA.Mode = CipherMode.ECB;

                // Convert base64 encrypted value to byte array
                string sEncryptedMessage = i_sData;
                byte[] CipherBytes = new byte[sEncryptedMessage.Length];
                CipherBytes = Convert.FromBase64String(sEncryptedMessage);

                // Create decryptor
                ICryptoTransform decryptor = oSA.CreateDecryptor();

                // Do decryption
                byte[] PlainBytes = decryptor.TransformFinalBlock(CipherBytes, 0, CipherBytes.Length);

                sDecodedMessage = Encoding.ASCII.GetString(PlainBytes);

                oSA.Clear();

                bStatus = true;
            }
            catch (Exception exp)
            {
                sDecodedMessage = "";
                bStatus = false;

                //AppException ex = new AppException("Error while decrypting the data.", exp);
                throw exp;
            }
            finally
            {
                o_sDecryptedData = sDecodedMessage;
            }

            return bStatus;
        }

        /// <summary>
        /// Decrypts the data using "Rijndael" symmetric algorithm.
        /// </summary>
        /// <param name="i_sData">Encrypted data that is to be decrypted</param>
        /// <param name="i_sKey">Key to be used to decrypt the data</param>
        /// <param name="o_sDecryptedData">Decrypted data value</param>
        /// <returns>
        /// true = Success
        /// false = Failure
        /// </returns>
        public bool SymmetricDecryption(string i_sData, out string o_sDecryptedData)
        {
            // Hardcoded decryption key and IV. Same key and IV are used for encrypting the message.
            string sVal = "Ps46klO0argt3mqY7FuwHt9zHQjv64LX";
            byte[] btIV = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
            byte[] btKey = Encoding.ASCII.GetBytes(sVal.ToCharArray());

            bool bStatus = false;
            string sDecodedMessage = "";

            if (i_sData == "")
            {
                bStatus = true;
                o_sDecryptedData = sDecodedMessage;

                return bStatus;
            }

            try
            {
                SymmetricAlgorithm oSA = SymmetricAlgorithm.Create("Rijndael");
                oSA.Key = btKey;
                oSA.IV = btIV;
                oSA.Mode = CipherMode.ECB;

                // Convert base64 encrypted value to byte array
                string sEncryptedMessage = i_sData;
                byte[] CipherBytes = new byte[sEncryptedMessage.Length];
                CipherBytes = Convert.FromBase64String(sEncryptedMessage);

                // Create decryptor
                ICryptoTransform decryptor = oSA.CreateDecryptor();

                // Do decryption
                byte[] PlainBytes = decryptor.TransformFinalBlock(CipherBytes, 0, CipherBytes.Length);

                sDecodedMessage = Encoding.ASCII.GetString(PlainBytes);

                oSA.Clear();

                bStatus = true;
            }
            catch (Exception exp)
            {
                sDecodedMessage = "";
                bStatus = false;

                //AppException ex = new AppException("Error while decrypting the data.", exp);
                throw exp;
            }
            finally
            {
                o_sDecryptedData = sDecodedMessage;
            }

            return bStatus;
        }

        public const int SALT_BYTE_SIZE = 30;
        public const int HASH_BYTE_SIZE = 30;
        public const int PBKDF2_ITERATIONS = 1000;    

        /// <summary>
        /// Creates a salted PBKDF2 hash of the password.
        /// </summary>
        /// <param name="password">The password to hash.</param>
        /// <returns>The hash of the password.</returns>
        public string CreateHash(string password,String SaltValue)
        {            
            RNGCryptoServiceProvider csprng = new RNGCryptoServiceProvider();
            byte[] salt = new byte[SALT_BYTE_SIZE];
            string[] temp = new string[30];          
            temp = SaltValue.Split(new string[] { "-" }, StringSplitOptions.None);
            for (int i = 0; i < SALT_BYTE_SIZE; i++)
            {
                salt[i] = Convert.ToByte(temp[i]);
            }           
            byte[] hash = PBKDF2(password, salt, PBKDF2_ITERATIONS, HASH_BYTE_SIZE);
            return Convert.ToBase64String(hash);
        }

        public string CreateHashToVerify(string password, string Salt)
        {
            byte[] _salt = Convert.FromBase64String(Salt);
            byte[] hash = PBKDF2(password, _salt, PBKDF2_ITERATIONS, HASH_BYTE_SIZE);
            return Convert.ToBase64String(hash);
        }

        /// <summary>
        /// Computes the PBKDF2-SHA1 hash of a password.
        /// </summary>
        /// <param name="password">The password to hash.</param>
        /// <param name="salt">The salt.</param>
        /// <param name="iterations">The PBKDF2 iteration count.</param>
        /// <param name="outputBytes">The length of the hash to generate, in bytes.</param>
        /// <returns>A hash of the password.</returns>
        private static byte[] PBKDF2(string password, byte[] salt, int iterations, int outputBytes)
        {
            Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt);
            pbkdf2.IterationCount = iterations;
            return pbkdf2.GetBytes(outputBytes);
        }



        /// <summary>
        /// Creates a hash and salt for new user.
        /// </summary>
        /// <param name="password">The login password to hash and salt.</param>
        /// <returns>The hash and salt of the password.</returns>
        public string CreateSaltandHash(string password)
        {
            RNGCryptoServiceProvider csprng = new RNGCryptoServiceProvider();
            byte[] salt = new byte[SALT_BYTE_SIZE];
            csprng.GetBytes(salt);
            byte[] hash = PBKDF2(password, salt, PBKDF2_ITERATIONS, HASH_BYTE_SIZE);
            string savedPasswordsalt = Convert.ToBase64String(salt);
            string savedPasswordHash = Convert.ToBase64String(hash);
            string concateHashSalt = savedPasswordHash + "~" + savedPasswordsalt;
            return concateHashSalt;
        }

        #region EncryptData & DecryptData
        /// <summary>
        /// This method is used to encrypt the text
        /// </summary>
        /// <param name="stringToEncrypt">value which we need to encrypt</param>
        /// <returns>returns the encrypted text</returns>
        public string EncryptData(string stringToEncrypt)
        {
            TripleDESCryptoServiceProvider cryptoProvider = new TripleDESCryptoServiceProvider();
            MD5CryptoServiceProvider md5Hash = new MD5CryptoServiceProvider();

            string key = "esop";

            if (key != null && key.Trim() != "" && stringToEncrypt != null)
            {
                byte[] KeyHash = md5Hash.ComputeHash(ASCIIEncoding.ASCII.GetBytes(key));

                cryptoProvider.Key = KeyHash;
                cryptoProvider.Mode = CipherMode.ECB;

                byte[] buffer = ASCIIEncoding.ASCII.GetBytes(stringToEncrypt);
                stringToEncrypt = Convert.ToBase64String(
                                cryptoProvider.CreateEncryptor().TransformFinalBlock(buffer, 0, buffer.Length)
                                );
            }
            return stringToEncrypt;
        }

        /// <summary>
        /// This method is used to decrypt the text
        /// </summary>
        /// <param name="Data">value which we need to decrypt</param>
        /// <returns>returns the decrypted text</returns>
        public string DecryptData(string Data)
        {
            try
            {
                string stringToDecrypt = string.Empty;
                stringToDecrypt = Data;
                TripleDESCryptoServiceProvider cryptoProvider = new TripleDESCryptoServiceProvider();
                MD5CryptoServiceProvider md5Hash = new MD5CryptoServiceProvider();
                string key = "esop";

                if (key != null && key.Trim() != "" && stringToDecrypt != null && stringToDecrypt.Trim() != "")
                {
                    byte[] passwordHash = md5Hash.ComputeHash(ASCIIEncoding.ASCII.GetBytes(key));

                    cryptoProvider.Key = passwordHash;
                    cryptoProvider.Mode = CipherMode.ECB;

                    byte[] buffer = Convert.FromBase64String(stringToDecrypt);
                    stringToDecrypt = ASCIIEncoding.ASCII.GetString(
                        cryptoProvider.CreateDecryptor().TransformFinalBlock(buffer, 0, buffer.Length)
                        );
                }
                return stringToDecrypt;
            }
            catch
            {
                throw new Exception("Invalid Connection Parameters");
            }
        }
        #endregion

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }


        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
