﻿using System;
using System.Collections.Generic;
using System.Globalization;
using System.Windows.Data;
using ClassIsland.Core;
using ClassIsland.Core.Models.Profile;
using ClassIsland.Models;

namespace ClassIsland.Converters;

public class DictionaryValueAccessConverter : IValueConverter
{
    public ObservableDictionary<string, Subject> SourceDictionary
    {
        get;
        set;
    } = new();

    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        var k = (string)value;
        try
        {
            return SourceDictionary[k].Name;
        }
        catch
        {
            return k;
        }
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture) => null;
}