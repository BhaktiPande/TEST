using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;

namespace DataUploadUtility
{
    /// <summary>
    /// This class is used to create Extension method
    /// </summary>
    public static class ExtensionClass
    {
        /// <summary>
        /// This method is used to convert list to datatble
        /// </summary>
        /// <typeparam name="T">T is any generic type</typeparam>
        /// <param name="listCollection">List</param>
        /// <returns>DataTable</returns>
        public static DataTable ToDataTable<T>(this IList<T> listCollection)
        {
            try
            {
                using (DataTable dt_ConvertedDataTable = new DataTable())
                {
                    PropertyDescriptorCollection propertyDescriptorCollection = TypeDescriptor.GetProperties(typeof(T));
                    
                    foreach (PropertyDescriptor propDesc in propertyDescriptorCollection)
                    {
                        dt_ConvertedDataTable.Columns.Add(propDesc.Name, Nullable.GetUnderlyingType(propDesc.PropertyType) ?? propDesc.PropertyType);
                    }

                    object[] values = new object[propertyDescriptorCollection.Count];

                    foreach (T perItem in listCollection)
                    {
                        for (int i = 0; i < values.Length; i++)
                        {
                            values[i] = propertyDescriptorCollection[i].GetValue(perItem);
                        }
                        dt_ConvertedDataTable.Rows.Add(values);
                    }
                    return dt_ConvertedDataTable;
                }
            }
            catch
            {
                throw;
            }
        }
    }
}
