/*
 * --------------------------------------------------------------------------------
 * <copyright company="Aspose" file="DocumentProperties.java">
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
 * The collection of document properties.
 */
@ApiModel(description = "The collection of document properties.")
public class DocumentProperties extends LinkElement {
    @SerializedName("List")
    protected List<DocumentProperty> list;
    /**
     * Gets or sets the collection of document properties.
    * @return list
    **/
    @ApiModelProperty(value = "Gets or sets the collection of document properties.")
    public List<DocumentProperty> getList() {
        return list;
    }

    public DocumentProperties list(List<DocumentProperty> list) {
        this.list = list;
        return this;
    }

    public DocumentProperties addListItem(DocumentProperty listItem) {
        if (this.list == null) {
            this.list = new ArrayList<DocumentProperty>();
        }
        this.list.add(listItem);
        return this;
    }


    public void setList(List<DocumentProperty> list) {
        this.list = list;
    }


    public DocumentProperties() {
        super();
        this.list = null;
    }

    @Override
    public boolean equals(java.lang.Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        DocumentProperties documentProperties = (DocumentProperties) o;
        return
            Objects.equals(this.list, documentProperties.list) &&
            super.equals(o);
  }

  @Override
  public int hashCode() {
    return Objects.hash(list, super.hashCode());
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class DocumentProperties {\n");
    sb.append("    link: ").append(toIndentedString(getLink())).append("\n");
    sb.append("    list: ").append(toIndentedString(getList())).append("\n");
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