/*
 * --------------------------------------------------------------------------------
 * <copyright company="Aspose" file="WatermarkText.java">
 *   Copyright (c) 2022 Aspose.Words for Cloud
 * </copyright>
 * <summary>
 *   Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 * 
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 * </summary>
 * --------------------------------------------------------------------------------
 */

package com.aspose.words.cloud.model;

import java.util.Objects;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import org.threeten.bp.OffsetDateTime;
import com.aspose.words.cloud.model.*;
import com.google.gson.TypeAdapter;
import com.google.gson.annotations.JsonAdapter;
import com.google.gson.annotations.SerializedName;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * Class for insert watermark text request building.
 */
@ApiModel(description = "Class for insert watermark text request building.")
public class WatermarkText {
    @SerializedName("RotationAngle")
    protected Double rotationAngle;

    @SerializedName("Text")
    protected String text;
    /**
     * Gets or sets the watermark rotation angle.
    * @return rotationAngle
    **/
    @ApiModelProperty(value = "Gets or sets the watermark rotation angle.")
    public Double getRotationAngle() {
        return rotationAngle;
    }

    public WatermarkText rotationAngle(Double rotationAngle) {
        this.rotationAngle = rotationAngle;
        return this;
    }

    public void setRotationAngle(Double rotationAngle) {
        this.rotationAngle = rotationAngle;
    }


    /**
     * Gets or sets the watermark text.
    * @return text
    **/
    @ApiModelProperty(value = "Gets or sets the watermark text.")
    public String getText() {
        return text;
    }

    public WatermarkText text(String text) {
        this.text = text;
        return this;
    }

    public void setText(String text) {
        this.text = text;
    }


    public WatermarkText() {
        this.rotationAngle = null;
        this.text = null;
    }

    @Override
    public boolean equals(java.lang.Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        WatermarkText watermarkText = (WatermarkText) o;
        return
            Objects.equals(this.rotationAngle, watermarkText.rotationAngle) &&
            Objects.equals(this.text, watermarkText.text);
  }

  @Override
  public int hashCode() {
    return Objects.hash(rotationAngle, text);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class WatermarkText {\n");
    sb.append("    rotationAngle: ").append(toIndentedString(getRotationAngle())).append("\n");
    sb.append("    text: ").append(toIndentedString(getText())).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(java.lang.Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}
