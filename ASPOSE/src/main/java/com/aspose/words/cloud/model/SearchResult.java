/*
 * --------------------------------------------------------------------------------
 * <copyright company="Aspose" file="SearchResult.java">
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
 * Result of search operation.
 */
@ApiModel(description = "Result of search operation.")
public class SearchResult {
    @SerializedName("RangeEnd")
    protected DocumentPosition rangeEnd;

    @SerializedName("RangeStart")
    protected DocumentPosition rangeStart;
    /**
     * Gets or sets the link to result range end node.
    * @return rangeEnd
    **/
    @ApiModelProperty(value = "Gets or sets the link to result range end node.")
    public DocumentPosition getRangeEnd() {
        return rangeEnd;
    }

    public SearchResult rangeEnd(DocumentPosition rangeEnd) {
        this.rangeEnd = rangeEnd;
        return this;
    }

    public void setRangeEnd(DocumentPosition rangeEnd) {
        this.rangeEnd = rangeEnd;
    }


    /**
     * Gets or sets the link to result range start node.
    * @return rangeStart
    **/
    @ApiModelProperty(value = "Gets or sets the link to result range start node.")
    public DocumentPosition getRangeStart() {
        return rangeStart;
    }

    public SearchResult rangeStart(DocumentPosition rangeStart) {
        this.rangeStart = rangeStart;
        return this;
    }

    public void setRangeStart(DocumentPosition rangeStart) {
        this.rangeStart = rangeStart;
    }


    public SearchResult() {
        this.rangeEnd = null;
        this.rangeStart = null;
    }

    @Override
    public boolean equals(java.lang.Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        SearchResult searchResult = (SearchResult) o;
        return
            Objects.equals(this.rangeEnd, searchResult.rangeEnd) &&
            Objects.equals(this.rangeStart, searchResult.rangeStart);
  }

  @Override
  public int hashCode() {
    return Objects.hash(rangeEnd, rangeStart);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class SearchResult {\n");
    sb.append("    rangeEnd: ").append(toIndentedString(getRangeEnd())).append("\n");
    sb.append("    rangeStart: ").append(toIndentedString(getRangeStart())).append("\n");
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