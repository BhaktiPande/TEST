using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class MassUploadDTO
    {
        [PetaPoco.Column("MassUploadExcelId")]
        public int MassUploadExcelId { get; set; }

        [PetaPoco.Column("MassUploadName")]
        public string MassUploadName { get; set; }

        [PetaPoco.Column("HasMultipleSheets")]
        public bool HasMultipleSheets { get; set; }

        [PetaPoco.Column("TemplateFileName")]
        public string TemplateFileName { get; set; }

        [PetaPoco.Column("MassUploadExcelSheetId")]
        public int MassUploadExcelSheetId { get; set; }

        [PetaPoco.Column("SheetName")]
        public string SheetName { get; set; }

        [PetaPoco.Column("IsPrimarySheet")]
        public bool IsPrimarySheet { get; set; }

        [PetaPoco.Column("ProcedureUsed")]
        public string ProcedureUsed { get; set; }

        [PetaPoco.Column("ParentSheetName")]
        public string ParentSheetName { get; set; }

        [PetaPoco.Column("MassUploadExcelDataTableColumnMappingId")]
        public int MassUploadExcelDataTableColumnMappingId { get; set; }

        [PetaPoco.Column("ExcelColumnNo")]
        public int ExcelColumnNo { get; set; }

        [PetaPoco.Column("MassUploadDataTableId")]
        public int MassUploadDataTableId { get; set; }

        [PetaPoco.Column("MassUploadDataTableName")]
        public string MassUploadDataTableName { get; set; }

        [PetaPoco.Column("MassUploadDataTablePropertyNo")]
        public int MassUploadDataTablePropertyNo { get; set; }

        [PetaPoco.Column("MassUploadDataTablePropertyName")]
        public string MassUploadDataTablePropertyName { get; set; }

        [PetaPoco.Column("MassUploadDataTablePropertyDataType")]
        public string MassUploadDataTablePropertyDataType { get; set; }

        [PetaPoco.Column("MassUploadDataTablePropertyDataSize")]
        public string MassUploadDataTablePropertyDataSize { get; set; }

        [PetaPoco.Column("RelatedMassUploadRelatedSheetId")]
        public int RelatedMassUploadRelatedSheetId { get; set; }

        [PetaPoco.Column("RelatedMassUploadExcelSheetColumnNo")]
        public int RelatedMassUploadExcelSheetColumnNo { get; set; }

        [PetaPoco.Column("ApplicableDataCodeGroupId")]
        public int? ApplicableDataCodeGroupId { get; set; }

        [PetaPoco.Column("ColumnCount")]
        public int ColumnCount { get; set; }

        [PetaPoco.Column("IsRequiredField")]
        public bool IsRequired { get; set; }

        [PetaPoco.Column("ValidationRegularExpression")]
        public string ValidationRegExpress { get; set; }

        [PetaPoco.Column("MaxLength")]
        public int MaxLength { get; set; }

        [PetaPoco.Column("MinLength")]
        public int MinLength { get; set; }

        [PetaPoco.Column("IsRequiredErrorCode")]
        public string IsRequiredErrorCode { get; set; }

        [PetaPoco.Column("ValidationRegExpressionErrorCode")]
        public string ValidationRegExpErrorcode { get; set; }

        [PetaPoco.Column("MaxLengthErrorCode")]
        public string MaxLengthErrorCode { get; set; }

        [PetaPoco.Column("MinLengthErrorCode")]
        public string MinLengthErrorCode { get; set; }

        [PetaPoco.Column("DependentColumnNo")]
        public int? DependentColumnNo { get; set; }

        [PetaPoco.Column("DependentColumnErrorCode")]
        public string DependentColumnErrorCode { get; set; }

        [PetaPoco.Column("DependentValueColumnNumber")]
        public int? DependentValueColumnNumber { get; set; }

        [PetaPoco.Column("DependentValueColumnValue")]
        public string DependentValueColumnValue { get; set; }

        [PetaPoco.Column("DependentValueColumnErrorCode")]
        public string DependentValueColumnErrorCode { get; set; }

        [PetaPoco.Column("DefaultValue")]
        public string DefaultValue { get; set; }
    }
}
