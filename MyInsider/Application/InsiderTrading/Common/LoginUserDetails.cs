using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Common
{
    public class LoginUserDetails
    {
        int m_nLoggedInUserID;
        /// <summary>
        /// This property will have the connection string to be used for communicating to the corresponding company database.
        /// This connection string will be build on the user login and will be available in the session to be used for any 
        /// further call.
        /// </summary>
        string m_sCompanyDBConnectionString;
        string m_sUserName;
        string m_sPassword;
        string m_sCompanyName;
        string m_sErrorMessage;
        string m_sSuccessMessage;
        string m_sFirstName;
        string m_sLastName;
        /// <summary>
        /// This message will be set when password is changed successfully as it will be required to be shown on the dashboard based on user after changing the password.
        /// </summary>
        string m_sPasswordChangeMessage;
        string m_sEmailID;
        /// <summary>
        /// This property will be used to flag if username/ password/ company authentication for user is done or not. This
        /// check is done in AuthorizationPrivilegeFilter so to reduce repeated authentication check on every call this flag is 
        /// introduced and is set to 1 on first time authorization.
        /// </summary>
        bool m_bIsAccountValidated;
        /// <summary>
        /// This list will contain the <Controllername>/<action method name> for all the activities. This list will be used for
        /// authorizing if the login user has access to the given activity in the AuthorizationPrivilegeFilter.
        /// </summary>
        List<string> m_lstAuthorizedActions;
        /// <summary>
        /// This list will contain the activity id for all the activities. This list will be used for
        /// authorizing if the login user has access to the given activity. This will be used for showing
        /// or hiding the button/links based on the activity based permission to the login user. 
        /// </summary>
        List<int> m_lstAuthorisedActionId;

        /// <summary>
        /// This property will be used for saving the last login time for the user to be shown at 
        /// </summary>
        DateTime m_dtLastLoginTime;

        /// <summary>
        /// This list will contain mapping of the resource with the activity in 
        /// order to edit and manditory the form field.
        /// </summary>
        Dictionary<string, List<ActivityResourceMappingDTO>> m_lstActivityResourceMappingDTO;

        Dictionary<string, DocumentDetailsDTO> m_lstDocumentDetailsDTO;

        int m_nUserTypeCodeId;

        string m_sCompanyLogoURL;

        string m_sBackURL;
        /// <summary>
        /// This contains the value encrypted value saved in client side cookie for verifying if the request is valid.
        /// </summary>
        string m_clientSideKey;
        /// <summary>
        /// This property is used to disaply notification popup 
        /// </summary>
        bool m_bShowNotificationPopup = true;
        //Roles collection can also come here.

        /// <summary>
        /// For saving the menu state in session
        /// </summary>
        string m_sSelectedParentID;
        string m_sSelectedChildId;

        bool m_bIsUserLogin = false;

        DateTime? m_DateOfBecomingInsider;

        public LoginUserDetails()
        {

        }

        #region Properties

        #region LoggedInUserID
        /// Gets or LoggedInUserID
        public int LoggedInUserID
        {
            get
            {
                return m_nLoggedInUserID;
            }
            set
            {
                m_nLoggedInUserID = value;
            }
        }
        #endregion LoggedInUserID

        #region IsAccountValidated
        /// Gets or IsAccountValidated
        public bool IsAccountValidated
        {
            get
            {
                return m_bIsAccountValidated;
            }
            set
            {
                m_bIsAccountValidated = value;
            }
        }
        #endregion IsAccountValidated

        #region CompanyDBConnectionString
        /// Gets or CompanyDBConnectionString
        public string CompanyDBConnectionString
        {
            get
            {
                return m_sCompanyDBConnectionString;
            }
            set
            {
                m_sCompanyDBConnectionString = value;
            }
        }
        #endregion CompanyDBConnectionString

        #region UserName
        /// Gets or UserName
        public string UserName
        {
            get
            {
                return m_sUserName;
            }
            set
            {
                m_sUserName = value;
            }
        }
        #endregion UserName

        #region Password
        /// Gets or Password
        public string Password
        {
            get
            {
                return m_sPassword;
            }
            set
            {
                m_sPassword = value;
            }
        }
        #endregion Password

        #region EmailID
        /// Gets or Set EmailID
        public string EmailID
        {
            get
            {
                return m_sEmailID;
            }
            set
            {
                m_sEmailID = value;
            }
        }
        #endregion EmailID

        #region CompanyName
        /// Gets or CompanyName
        public string CompanyName
        {
            get
            {
                return m_sCompanyName;
            }
            set
            {
                m_sCompanyName = value;
            }
        }
        #endregion CompanyName

        #region m_sErrorMessage
        /// Gets or ErrorMessage
        public string ErrorMessage
        {
            get
            {
                return m_sErrorMessage;
            }
            set
            {
                m_sErrorMessage = value;
            }
        }
        #endregion ErrorMessage

        #region SuccessMessage
        /// Gets or SuccessMessage
        public string SuccessMessage
        {
            get
            {
                return m_sSuccessMessage;
            }
            set
            {
                m_sSuccessMessage = value;
            }
        }
        #endregion ErrorMessage

        #region FirstName
        /// Gets or FirstName
        public string FirstName
        {
            get
            {
                return m_sFirstName;
            }
            set
            {
                m_sFirstName = value;
            }
        }
        #endregion FirstName

        #region LastName
        /// Gets or LastName
        public string LastName
        {
            get
            {
                return m_sLastName;
            }
            set
            {
                m_sLastName = value;
            }
        }
        #endregion LastName

        #region AuthorizedActions
        /// Gets or AuthorizedActions
        public List<string> AuthorizedActions
        {
            get
            {
                return m_lstAuthorizedActions;
            }
            set
            {
                m_lstAuthorizedActions = value;
            }
        }
        #endregion AuthorizedActions

        #region AuthorisedActionId
        /// Gets or AuthorisedActionId
        public List<int> AuthorisedActionId
        {
            get
            {
                return m_lstAuthorisedActionId;
            }
            set
            {
                m_lstAuthorisedActionId = value;
            }
        }
        #endregion AuthorisedActionId

        #region ActivityResourceMapping
        /// Gets or set ListActivityResourceMapping
        public Dictionary<string, List<ActivityResourceMappingDTO>> ActivityResourceMapping
        {
            get
            {
                return m_lstActivityResourceMappingDTO;
            }
            set
            {
                m_lstActivityResourceMappingDTO = value;
            }
        }
        #endregion ActivityResourceMapping

        #region DocumentDetailsDTO
        /// Temporary storage for Document uploaded
        public Dictionary<string, DocumentDetailsDTO> DocumentDetails
        {
            get
            {
                return m_lstDocumentDetailsDTO;
            }
            set
            {
                m_lstDocumentDetailsDTO = value;
            }
        }
        #endregion DocumentDetailsDTO

        #region UserTypeCodeId
        public int UserTypeCodeId
        {
            get
            {
                return m_nUserTypeCodeId;
            }
            set
            {
                m_nUserTypeCodeId = value;
            }
        }
        #endregion UserTypeCodeId

        #region CompanyLogoURL
        /// Gets or set CompanyLogoURL
        public string CompanyLogoURL
        {
            get
            {
                return m_sCompanyLogoURL;
            }
            set
            {
                m_sCompanyLogoURL = value;
            }
        }
        #endregion CompanyLogoURL

        #region PasswordChangeMessage
        /// Gets or PasswordChangeMessage
        public string PasswordChangeMessage
        {
            get
            {
                return m_sPasswordChangeMessage;
            }
            set
            {
                m_sPasswordChangeMessage = value;
            }
        }
        #endregion PasswordChangeMessage

        #region LastLoginTime
        /// Gets or LastLoginTime
        public DateTime LastLoginTime
        {
            get
            {
                return m_dtLastLoginTime;
            }
            set
            {
                m_dtLastLoginTime = value;
            }
        }
        #endregion LastLoginTime

        #region ShowNotificationPopup
        /// Gets or ShowNotificationPopup
        public bool ShowNotificationPopup
        {
            get
            {
                return m_bShowNotificationPopup;
            }
            set
            {
                m_bShowNotificationPopup = value;
            }
        }
        #endregion ShowNotificationPopup

        #region BackURL
        /// Gets or set BackURL
        public string BackURL
        {
            get
            {
                return m_sBackURL;
            }
            set
            {
                m_sBackURL = value;
            }
        }
        #endregion BackURL

        #region ClientSideKey
        /// Gets or set ClientSideKey
        public string ClientSideKey
        {
            get
            {
                return m_clientSideKey;
            }
            set
            {
                m_clientSideKey = value;
            }
        }
        #endregion ClientSideKey

        #region SelectedParentID
        public string SelectedParentID
        {
            get
            {
                return m_sSelectedParentID;
            }
            set
            {
                m_sSelectedParentID = value;
            }
        }
        #endregion SelectedParentID

        #region SelectedChildId
        public string SelectedChildId
        {
            get
            {
                return m_sSelectedChildId;
            }
            set
            {
                m_sSelectedChildId = value;
            }
        }
        #endregion SelectedChildId

        #region IsUserLogin
        public bool IsUserLogin
        {
            get { return m_bIsUserLogin; }
            set { m_bIsUserLogin = value; }
        }
        #endregion IsUserLogin

        #region DateOfBecomingInsider
        public DateTime? DateOfBecomingInsider
        {
            get { return m_DateOfBecomingInsider; }
            set { m_DateOfBecomingInsider = value; }
        }
        #endregion
        #endregion
    }
}