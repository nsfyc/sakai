import { RubricsElement } from "./rubrics-element.js";
import { html } from "/webcomponents/assets/lit-element/lit-element.js";
import { rubricsApiMixin } from "./sakai-rubrics-api-mixin.js";

/**
 * @property {string} siteId
 * @property {string} toolId
 * @property {string} entityId
 * @property {string} summaryType
 */
export class SakaiRubricSummary extends rubricsApiMixin(RubricsElement) {

  static get properties() {

    return {
      siteId: { attribute: "site-id", type: String },
      toolId: { attribute: "tool-id", type: String },
      entityId: { attribute: "entity-id", type: String },
      summaryType: { attribute: "summary-type", type: String },
      // Non attribute
      criteria: { attribute: false, type: Array },
      rubric: { attribute: false, type: Object },
      allEvaluations: { attribute: false, type: Array },
      averages: { attribute: false, type: Map },
      averageScore: { attribute: false, type: Number },
    };
  }

  constructor() {

    super();

    this.summaryType = "student";
  }

  connectedCallback() {

    super.connectedCallback();

    this.criteria = [];
    if (this.isConnected) {

      if (this.siteId && this.toolId && this.entityId) {
        this._getAssociation();
        this._getAllEvaluations();
      }
    }
  }

  render() {

    if (this.summaryType === "criteria") {
      return html`
        <div class="d-flex justify-content-between align-items-center mb-2">
          <h3><sr-lang key="criteria_summary">CRITERIA</sr-lang></h3>
          <div class="collapse-toggle-buttons">
            <button type="button" class="btn btn-link" @click=${this._expandAll}><sr-lang key="expand_all">expand all</sr-lang></button>
            <button type="button" class="btn btn-link" @click=${this._collapseAll}><sr-lang key="collapse_all">collapse all</sr-lang></button>
          </div>
        </div>
        ${!this.allEvaluations?.length ? html`
          <div class="sak-banner-warn">
            <sr-lang key="no_evaluations_warning">WARN</sr-lang>
          </div>
        ` : html`
          ${this.criteria.map((c) => html`
            <div class="mb-2">
              <div class="card">
                <div class="card text-center">
                  <h4>
                    <a class="collapse-toggle collapsed" data-bs-toggle="collapse" href="#collapse${c.id}">${c.title}</a>
                  </h4>
                </div>
                <div id="collapse${c.id}" class="collapse">
                  <div class="card-body">
                    <div class="table">
                      <table class="rubrics-summary-table table table-bordered table-sm">
                        <tr>
                          ${c.ratings.map(r => html`
                            <th class="rubrics-summary-table-cell">
                                <div>
                                    ${this.rubric.weighted ? html`
                                      (${r.weightedPoints})        
                                    ` : html``}
                                    ${r.points} 
                                    <sr-lang key="points">points</sr-lang></div>
                                <div class="summary-rating-name" title="${r.title}">${this._limitCharacters(r.title, 20)}</div>
                            </th>
                            ${this.association.parameters.fineTunePoints && this._getCustomCount(c.id, r.weightedPoints) > 0 ? html`
                              <th class="rubrics-summary-table-cell"><sr-lang key="adjusted_score">adjustedscore</sr-lang></th>
                            ` : ""}
                          `)}
                          <th class="rubrics-summary-table-cell rubrics-summary-average-cell d-none"><sr-lang key="average">average</sr-lang></th>
                          <th  class="rubrics-summary-table-cell d-none"><sr-lang key="median">median</sr-lang></th>
                          <th  class="rubrics-summary-table-cell d-none"><sr-lang key="stdev">stdev</sr-lang></th>
                        </tr>
                        <tr>
                          ${c.ratings.map(r => html`
                            <td class="points-${r.points} rubrics-summary-table-cell point-cell-${c.id}">${this._getACount(c.id, r.id)}</td>
                            ${this.association.parameters.fineTunePoints && this._getCustomCount(c.id, r.weightedPoints) > 0 ? html`
                              <td class="rubrics-summary-table-cell">${this._getCustomCount(c.id, r.weightedPoints)}</td>
                            ` : html``}
                          `)}
                          <td class="rubrics-summary-table-cell rubrics-summary-average-cell d-none">${this._getPointsAverage(c.id)}</td>
                          <td class="rubrics-summary-table-cell d-none">${this._getPointsMedian(c.id)}</td>
                          <td  class="rubrics-summary-table-cell d-none">${this._getPointsStdev(c.id)}</td>
                        </tr>
                      </table>
                    </div>
                    <dl class="dl-horizontal mb-0">
                        <dt><sr-lang key="average">average</sr-lang></dt>
                        <dd>
                            ${this._getPointsAverage(c.id)}
                        </dd>
                        <dt><sr-lang key="median">median</sr-lang></dt>
                        <dd>
                            ${this._getPointsMedian(c.id)}
                        </dd>
                        <dt><sr-lang key="stdev">stdev</sr-lang></dt>
                        <dd>
                            ${this._getPointsStdev(c.id)}
                        </dd>
                    </dl>
                  </div>
                </div>
              </div>
            </div>
          `)}
          <div><sr-lang key="adjusted_score_warning">adjustedscorewarning</sr-lang></div>
        `}
      `;
    }

    return html`
      <h3><sr-lang key="student_summary">studentsummary</sr-lang></h3>
      ${!this.allEvaluations?.length ? html`
      <div class="sak-banner-warn">
        <sr-lang key="no_evaluations_warning">WARN</sr-lang>
      </div>
      ` : html`
      <div class="table">
        <table id="student-summary" class="rubrics-summary-table table table-bordered table-sm">
          <thead>
            <tr>
              <th class="rubrics-summary-table-cell rubrics-summary-table-cell-wide"><sr-lang key="student_name">studentname</sr-lang></th>
              ${this.criteria.map(c => html`<th class="rubrics-summary-table-cell" >${c.title}</th>`)}
              <th class="rubrics-summary-table-cell rubrics-summary-average-cell"><sr-lang key="score">score</sr-lang></th>
            </tr>
          </thead>
          <tbody>
          ${this.allEvaluations.map(e => html`
            <tr>
              <td class="rubrics-summary-table-cell rubrics-summary-table-cell-wide nameColumn">${e.sortName}</td>
              ${e.criterionOutcomes.map(o => html`
              <td class="rubrics-summary-table-cell rubrics-summary-table-cell point-cell-${o.criterionId}" >${o.points}</td>
              `)}
              <td class="rubrics-summary-table-cell rubrics-summary-average-cell point-cell-score" >${e.score}</td>
            </tr>
          `)}
          </tbody>
          <tfoot>
            <tr>
              <th class="rubrics-summary-table-cell rubrics-summary-table-cell-wide rubrics-summary-average-row " ><sr-lang key="average">average</sr-lang></th>
              ${this.criteria.map(c => html`
              <td class="rubrics-summary-table-cell rubrics-summary-average-row">${this.averages.get(c.id)}</td>
              `)}
              <td class="rubrics-summary-table-cell rubrics-summary-average-cell rubrics-summary-average-row" >${this.averageScore}</td>
            </tr>
          </tfoot>
        </table>
      </div>
      ` }
    `;
  }

  _getAssociation() {

    this.apiGetAssociation()
      .then(association => {

        this.association = association;
        this.getRubric(association.rubricId);
      })
      .catch (error => console.error(error));
  }

  getRubric(rubricId) {

    this.apiGetRubric(rubricId)
      .then(rubric => {

        this.rubric = rubric;
        this.criteria = this.rubric.criteria;
      })
      .catch (error => console.error(error));
  }

  _getAllEvaluations() {

    this.apiGetAllEvaluations()
      .then(evaluations => {

        this.allEvaluations = evaluations;
        this.averages = new Map();
        this.averageScore = 0;
        let totalScores = 0;
        this.allEvaluations.forEach(evaluation => {

          totalScores += evaluation.score;

          evaluation.criterionOutcomes.forEach(co => {

            if (!this.averages.has(co.criterionId)) {
              this.averages.set(co.criterionId, co.points);
            } else {
              this.averages.set(co.criterionId, this.averages.get(co.criterionId) + co.points);
            }
          });
        });

        this.averages.forEach((v, k, m) => m.set(k, (v / this.allEvaluations.length).toFixed(2)));
        this.averageScore = (totalScores / this.allEvaluations.length).toFixed(2);
      })
      .catch (error => console.error(error));
  }

  _limitCharacters(text, chars) {

    if (text.length > parseInt(chars)) {
      return `${text.substring(0, parseInt(chars))}...`;
    }
    return text;
  }

  _getACount(criterionId, ratingId) {

    let total = 0;
    this.allEvaluations.forEach(evaluation => {

      evaluation.criterionOutcomes.forEach(oc => {

        if (oc.criterionId === parseInt(criterionId)
            && this._doesScoreMatchRating(oc.points, criterionId, ratingId)) {
          total = total + 1;
        }
      });
    });
    return total;
  }

  _doesScoreMatchRating(score, criterionId, ratingId) {

    const criterion = this.criteria.find(c => c.id === criterionId);
    //We can always use weightedPoints because it will simply be the normal value if the rubric is not weighted.
    return criterion.ratings.some(r => r.weightedPoints === parseFloat(score) && r.id === ratingId);
  }

  _getPointsAverage(criterionId) {

    let total = 0;
    this.allEvaluations.forEach(ev => {

      ev.criterionOutcomes.forEach(oc => {

        if (oc.criterionId === criterionId) {
          total = total + oc.points;
        }
      });
    });

    return (total / this.allEvaluations.length).toFixed(2);
  }

  _getPoints(criterionId) {

    const values = [];
    this.allEvaluations.forEach(ev => {

      ev.criterionOutcomes.forEach(oc => {

        if (oc.criterionId === criterionId) {
          values.push(oc.points);
        }
      });
    });
    return values;
  }

  _getPointsMedian(criterionId) {

    const values = this._getPoints(criterionId);

    if (values.length === 0) {
      return 0;
    }
    values.sort((a, b) => a - b);
    const half = Math.floor(values.length / 2);
    if (values.length % 2) {
      return values[half];
    }
    return ((values[half - 1] + values[half]) / 2.0).toFixed(2);
  }

  _getPointsStdev(criterionId) {

    const average = this._getPointsAverage(criterionId);
    const values = this._getPoints(criterionId);
    let total = 0;
    values.forEach(v => total = total + (average - v) * (average - v));
    total = total / values.length;
    return Math.sqrt(total).toFixed(2);
  }

  _getCustomCount(criterionId, floorPointsParam) {

    let ceilingPoints = 5000;
    const criterion = this.criteria.find(c => c.id === criterionId);
    const floorPoints = parseFloat(floorPointsParam);
    criterion.ratings.every(r => {

      if (r.weightedPoints > floorPoints) {
        ceilingPoints = r.weightedPoints;
        return false;
      }
      return true;
    });
    let total = 0;
    this.allEvaluations.forEach(ev => {

      ev.criterionOutcomes.forEach(oc => {

        if (oc.criterionId === parseFloat(criterionId) && oc.points > floorPoints && oc.points < ceilingPoints) {
          total = total + 1;
        }
      });
    });
    return total;
  }

  _expandAll() {

    this.querySelectorAll(".collapse-toggle.collapsed").forEach(el => el.click());
  }

  _collapseAll() {

    Array.from(this.querySelectorAll(".collapse-toggle"))
      .filter(el => !el.classList.contains("collapsed")).forEach(el => el.click());
  }
}
customElements.define("sakai-rubric-summary", SakaiRubricSummary);
