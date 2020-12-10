using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.Mvc;
namespace Mvc2Templates.Providers
{
    public class CustomModelMetadataProvider : DataAnnotationsModelMetadataProvider
    {

        Regex _camelCaseRegex = new Regex(@"\B\p{Lu}\p{Ll}", RegexOptions.Compiled);

        // Creates a nice DisplayName from the model’s property name if one hasn't been specified
        protected override ModelMetadata GetMetadataForProperty(
           Func<object> modelAccessor,
           Type containerType,
           PropertyDescriptor propertyDescriptor)
        {
            ModelMetadata metadata = base.GetMetadataForProperty(modelAccessor, containerType, propertyDescriptor);

            if (metadata.DisplayName != null && metadata.DisplayName.Contains("_"))
                metadata.DisplayName = displayNameFromCamelCase(metadata.GetDisplayName());

            return metadata;
        }

        string displayNameFromCamelCase(string name)
        {
            return Common.getResource(name);
        }
        
        protected override ModelMetadata CreateMetadata(
            IEnumerable<Attribute> attributes,
            Type containerType,
            Func<object> modelAccessor,
            Type modelType,
            string propertyName)
        {
            var modelMetadata = base.CreateMetadata(attributes, containerType, modelAccessor, modelType, propertyName);
            var attributesList = attributes.ToArray();
            ApplyConventionsToValidationAttributes(attributesList, containerType, propertyName);
                attributes.OfType<MetadataAttribute>().ToList().ForEach(x => x.Process(modelMetadata));

                var resourceKey = attributes.SingleOrDefault(a => a.GetType() == typeof(ResourceKeyAttribute));
                if (resourceKey != null) modelMetadata.AdditionalValues.Add("ResourceKey", ((ResourceKeyAttribute)resourceKey).Key);

            //added model attributeinto additional values to get into model meta data
            var activity_resource_key = attributes.SingleOrDefault(a => a.GetType() == typeof(ActivityResourceKeyAttribute));
            if (activity_resource_key != null) modelMetadata.AdditionalValues.Add("ActivityResourceKey", ((ActivityResourceKeyAttribute)activity_resource_key).Key);

            //if (modelAccessor == null)
            //{
            //    modelMetadata.DisplayName = Common.getResource(modelMetadata.DisplayName);
            //} 
            return modelMetadata;
        }

        private static void ApplyConventionsToValidationAttributes(IEnumerable<Attribute> attributes, Type containerType,
            string propertyName)
        {
            foreach (
                ValidationAttribute validationAttribute in attributes.Where(a => (a as ValidationAttribute != null)))
            {

                //if (string.IsNullOrEmpty(validationAttribute.ErrorMessage))
                //{

                if (!string.IsNullOrEmpty(Common.getResource(validationAttribute.ErrorMessage)))
                {
                    validationAttribute.ErrorMessage = Common.getResource(validationAttribute.ErrorMessage);
                }
                    //string resourceKey = containerType.Name + "_" + propertyName + "_" + validationAttribute.GetType().Name.Replace("Attribute", "");
                    //validationAttribute.ErrorMessageResourceType = null;
                //}
                    //string attributeShortName = validationAttribute.GetType().Name.Replace("Attribute", "");
                    //string resourceKey = GetResourceKey(containerType, propertyName) + "_" + attributeShortName;

                    //var resourceType = validationAttribute.ErrorMessageResourceType ?? defaultResourceType;

                    //if (!resourceType.PropertyExists(resourceKey))
                    //{
                    //    resourceKey = propertyName + "_" + attributeShortName;
                    //    if (!resourceType.PropertyExists(resourceKey))
                    //    {
                    //        resourceKey = "Error_" + attributeShortName;
                    //        if (!resourceType.PropertyExists(resourceKey))
                    //        {
                    //            continue;
                    //        }
                    //    }
                    //}

                    //validationAttribute.ErrorMessageResourceType = resourceType;
                    //validationAttribute.ErrorMessageResourceName = resourceKey;
                //}
            }
        }
    }

    /// <summary>
    /// Base class for custom MetadataAttributes.
    /// </summary>
    public abstract class MetadataAttribute : Attribute
    {
        /// <summary>
        /// Method for processing custom attribute data.
        /// </summary>
        /// <param name="modelMetaData">A ModelMetaData instance.</param>
        public abstract void Process(ModelMetadata modelMetaData);
    }


}