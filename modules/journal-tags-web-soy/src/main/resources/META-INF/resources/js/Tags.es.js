import Component from 'metal-component';
import dom from 'metal-dom';
import Soy from 'metal-soy';
import {Config} from 'metal-state';

import templates from './Tags.soy';

class Tags extends Component {

}

Tags.STATE = {
    hasTags: Config.bool().required(),
    hasOfficial: Config.bool().required(),
    unofficialTags: Config.array()
};

Soy.register(Tags, templates);

export {Tags};
export default Tags;