using System;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("du_MappingTables")]
    public class DataUploadUtilityDTO : IDisposable
    {
        [PetaPoco.Column("MappingTableID")]
        public int MappingTableID { get; set; }

        [PetaPoco.Column("ExcelSheetDetailsID")]
        public int ExcelSheetDetailsID { get; set; }

        [PetaPoco.Column("ActualTableName")]
        public string ActualTableName { get; set; }

        [PetaPoco.Column("DisplayName")]
        public string DisplayName { get; set; }

        [PetaPoco.Column("FilePath")]
        public string FilePath { get; set; }

        [PetaPoco.Column("FileName")]
        public string FileName { get; set; }

        [PetaPoco.Column("ExcelSheetName")]
        public string ExcelSheetName { get; set; }

        [PetaPoco.Column("UploadMode")]
        public string UploadMode { get; set; }

        [PetaPoco.Column("Query")]
        public string Query { get; set; }

        [PetaPoco.Column("ConnectionString")]
        public string ConnectionString { get; set; }

        [PetaPoco.Column("IsSFTPEnable")]
        public bool IsSFTPEnable { get; set; }

        [PetaPoco.Column("HostName")]
        public string HostName { get; set; }

        [PetaPoco.Column("UserName")]
        public string UserName { get; set; }

        [PetaPoco.Column("Password")]
        public string Password { get; set; }

        [PetaPoco.Column("PortNumber")]
        public int PortNumber { get; set; }

        [PetaPoco.Column("SshHostKeyFingerprint")]
        public string SshHostKeyFingerprint { get; set; }

        [PetaPoco.Column("SourceFilePath")]
        public string SourceFilePath { get; set; }

        #region IDisposable Members
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        void IDisposable.Dispose()
        {
            Dispose(true);
        }

        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }

    [PetaPoco.TableName("du_MappingTables")]
    public class MappingFieldsDTO : IDisposable
    {
        [PetaPoco.Column("MappingTableID")]
        public int MappingTableID { get; set; }

        [PetaPoco.Column("ExcelSheetDetailsID")]
        public int ExcelSheetDetailsID { get; set; }

        [PetaPoco.Column("MassUploadExcelId")]
        public int MassUploadExcelId { get; set; }

        [PetaPoco.Column("MassUploadExcelSheetId")]
        public int MassUploadExcelSheetId { get; set; }

        [PetaPoco.Column("DisplayName")]
        public string DisplayName { get; set; }

        [PetaPoco.Column("FilePath")]
        public string FilePath { get; set; }

        [PetaPoco.Column("ActualTableName")]
        public string ActualTableName { get; set; }

        [PetaPoco.Column("ActualFieldName")]
        public string ActualFieldName { get; set; }

        [PetaPoco.Column("ActualFieldDataType")]
        public string ActualFieldDataType { get; set; }

        [PetaPoco.Column("ActualFieldIsRequired")]
        public bool ActualFieldIsRequired { get; set; }

        [PetaPoco.Column("DisplayFieldName")]
        public string DisplayFieldName { get; set; }

        [PetaPoco.Column("ActualValueName")]
        public string ActualValueName { get; set; }

        [PetaPoco.Column("DisplayValueName")]
        public string DisplayValueName { get; set; }

        [PetaPoco.Column("IsPrimarySheet")]
        public bool IsPrimarySheet { get; set; }

        #region IDisposable Members
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        void IDisposable.Dispose()
        {
            Dispose(true);
        }

        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }

    [PetaPoco.TableName("mst_Company")]
    public class ImplementingCompanyDetails : IDisposable
    {
        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        #region IDisposable Members
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        void IDisposable.Dispose()
        {
            Dispose(true);
        }

        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
