using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading
{
    public class ResourceModel
    {
      
        public int? ResourceId { get; set; }

        [Required]
        [DisplayName("mst_lbl_10029")]
        public string ResourceKey { get; set; }

        [Required]
        [DisplayName("mst_lbl_10030")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "mst_msg_50502")]
        public string ResourceValue { get; set; }

        [Required]
        [DisplayName("mst_lbl_10031")]
        public string ResourceCulture { get; set; }

        [Required]
        [DisplayName("mst_lbl_10032")]
        public int? ModuleCodeId { get; set; }

        [Required]
        [DisplayName("mst_lbl_10033")]
        public int? CategoryCodeId { get; set; }

        [Required]
        [DisplayName("mst_lbl_10034")]
        public int? ScreenCodeId { get; set; }

        [Required]
        [DisplayName("mst_lbl_10035")]
        public string OriginalResourceValue { get; set; }

        [DisplayName("mst_lbl_10032")]
        public string ModuleCodeName { get; set; }

        [DisplayName("mst_lbl_10033")]
        public string CategoryCodeName { get; set; }

       [DisplayName("mst_lbl_10034")]
       public string ScreenName { get; set; }

      [DisplayName("mst_lbl_10039")]
       public int? GridTypeCodeId { get; set; }

      [DisplayName("mst_lbl_10039")]
      public string GridHeaderListName { get; set; }

      [DisplayName("mst_lbl_10040")]
      public bool IsVisible { get; set; }

      [Required]
      [DisplayName("mst_lbl_10041")]
      [RegularExpression("([0-9]+)", ErrorMessage = "mst_msg_10042")]
      public int? SequenceNumber { get; set; }

      [Required]
      [DisplayName("mst_lbl_10045")]
      public int? ColumnWidth { get; set; }

      [Required]
      [DisplayName("mst_lbl_10046")]
      public int? ColumnAlignment { get; set; }

    }
}